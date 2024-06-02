defmodule CenWeb.VacancyController do
  use CenWeb, :controller_with_specs

  alias Cen.Accounts
  alias Cen.Employers
  alias Cen.Employers.Vacancy
  alias CenWeb.Plugs.AccessRules
  alias CenWeb.Plugs.ResourceLoader
  alias CenWeb.Schemas.ChangesetErrorsResponse
  alias CenWeb.Schemas.CreateVacancyRequest
  alias CenWeb.Schemas.GenericErrorResponse
  alias CenWeb.Schemas.Vacancies.UpdateVacancyRequest
  alias CenWeb.Schemas.Vacancies.VacanciesQueryResponse
  alias CenWeb.Schemas.VacancyResponse
  alias CenWeb.UserAuth

  fallback = CenWeb.FallbackController
  action_fallback fallback

  plug AccessRules,
       [
         fallback: fallback,
         verify_fun: &Accounts.has_employer_permissions?/1,
         args_keys: [:current_user],
         reason: "You are not the employer"
       ]
       when action in [:create]

  plug ResourceLoader,
       [key: :vacancy, context: Employers, fallback: fallback]
       when action in [:show, :update, :delete]

  plug AccessRules,
       [
         fallback: fallback,
         verify_fun: &Employers.can_user_edit_vacancy?/2,
         args_keys: [:vacancy, :current_user],
         reason: "You are not the owner of the vacancy"
       ]
       when action in [:update, :delete]

  plug CenWeb.Plugs.CastAndValidate

  tags :vacancies

  operation :search,
    summary: "Search vacancies",
    parameters: [
      text: [
        in: :query,
        description: "Search text",
        type: :string
      ],
      "employment_types[]": [
        in: :query,
        description: "Employment types",
        schema: %OpenApiSpex.Schema{
          type: :array,
          items: %OpenApiSpex.Schema{type: :string, enum: Cen.Enums.employment_types()}
        }
      ],
      "work_schedules[]": [
        in: :query,
        description: "Employment types",
        schema: %OpenApiSpex.Schema{
          type: :array,
          items: %OpenApiSpex.Schema{type: :string, enum: Cen.Enums.work_schedules()}
        }
      ],
      education: [
        in: :query,
        description: "Education",
        schema: %OpenApiSpex.Schema{type: :string, enum: Cen.Enums.educations()}
      ],
      field_of_art: [
        in: :query,
        description: "Field of art",
        schema: %OpenApiSpex.Schema{type: :string, enum: Cen.Enums.field_of_arts()}
      ],
      years_of_work_experience: [in: :query, description: "Years of work experience", type: :integer],
      preferred_salary: [in: :query, description: "Preferred salary", type: :integer],
      page: [in: :query, description: "Page number", type: :integer],
      page_size: [in: :query, description: "Page size", type: :integer]
    ],
    responses: [
      ok: {"Vacancies list", "application/json", VacanciesQueryResponse}
    ]

  @spec search(Plug.Conn.t(), map()) :: Plug.Conn.t() | {:error, atom()}
  def search(conn, params) do
    page = Employers.search_vacancies(params)
    render(conn, :index, page: page)
  end

  operation :show,
    summary: "Get vacancy",
    parameters: [
      vacancy_id: [in: :path, description: "Vacancy ID", type: :integer, example: "10132"]
    ],
    responses: [
      created: {"Requested vacancy", "application/json", VacancyResponse},
      unauthorized: "Unauthorized",
      not_found: {"Vacancy not found", "application/json", GenericErrorResponse}
    ]

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t() | {:error, atom()}
  def show(conn, _params) do
    render(conn, :show, vacancy: fetch_vacancy(conn))
  end

  security [%{"user_auth" => ["employer"]}]

  operation :create,
    summary: "Create vacancy",
    request_body: {"Vacancy params", "application/json", CreateVacancyRequest},
    responses: [
      created: {"Created vacancy", "application/json", VacancyResponse},
      unauthorized: "Unauthorized",
      unprocessable_entity: {"Changeset errors", "application/json", ChangesetErrorsResponse}
    ]

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t() | {:error, atom()}
  def create(conn, %{"vacancy" => vacancy_params}) do
    current_user = UserAuth.fetch_current_user(conn)

    with {:ok, organization} <- Employers.fetch_organization_by_user(current_user),
         vacancy_params = Map.put(vacancy_params, :organization, organization),
         {:ok, %Vacancy{} = vacancy} <- Employers.create_vacancy(vacancy_params) do
      vacancy = Map.put(vacancy, :organization, organization)

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/vacancies/#{vacancy}")
      |> render(:show, vacancy: vacancy)
    end
  end

  operation :update,
    summary: "Update vacancy",
    parameters: [
      vacancy_id: [in: :path, description: "Vacancy ID", type: :integer, example: "10132"]
    ],
    request_body: {"Vacancy params", "application/json", UpdateVacancyRequest},
    responses: [
      created: {"Requested vacancy", "application/json", VacancyResponse},
      unauthorized: "Unauthorized",
      not_found: {"Vacancy not found", "application/json", GenericErrorResponse}
    ]

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t() | {:error, atom()}
  def update(conn, %{"vacancy" => vacancy_params}) do
    %{organization: org} = vacancy = fetch_vacancy(conn)

    updating_result = Employers.update_vacancy(vacancy, vacancy_params)

    with {:ok, vacancy} <- updating_result do
      render(conn, :show, vacancy: Map.put(vacancy, :organization, org))
    end
  end

  operation :delete,
    summary: "Delete vacancy",
    parameters: [
      vacancy_id: [in: :path, description: "Vacancy ID", type: :integer, example: "10132"]
    ],
    responses: [
      no_content: "Vacancy deleted",
      unauthorized: "Unauthorized"
    ]

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t() | {:error, atom()}
  def delete(conn, _params) do
    conn
    |> fetch_vacancy()
    |> Employers.delete_vacancy()

    send_resp(conn, :no_content, "")
  end

  defp fetch_vacancy(%{assigns: %{vacancy: vacancy}}), do: vacancy
end
