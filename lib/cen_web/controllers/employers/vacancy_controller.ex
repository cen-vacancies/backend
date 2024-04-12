defmodule CenWeb.VacancyController do
  use CenWeb, :controller_with_specs

  alias Cen.Employers
  alias Cen.Employers.Organization
  alias Cen.Employers.Vacancy
  alias CenWeb.Schemas.ChangesetErrorsResponse
  alias CenWeb.Schemas.CreateVacancyRequest
  alias CenWeb.Schemas.GenericErrorResponse
  alias CenWeb.Schemas.VacancyResponse

  action_fallback CenWeb.FallbackController

  tags :vacancies
  security [%{}, %{"user_auth" => ["employer"]}]

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t() | {:error, atom()}
  def index(conn, _params) do
    vacancies = Employers.list_vacancies()
    render(conn, :index, vacancies: vacancies)
  end

  operation :create,
    summary: "Create vacancy",
    parameters: [
      organization_id: [in: :path, description: "Organization ID", type: :integer, example: "10132"]
    ],
    request_body: {"Vacancy params", "application/json", CreateVacancyRequest},
    responses: [
      created: {"Created vacancy", "application/json", VacancyResponse},
      unauthorized: "Unauthorized",
      unprocessable_entity: {"Changeset errors", "application/json", ChangesetErrorsResponse}
    ]

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t() | {:error, atom()}
  def create(conn, %{"vacancy" => vacancy_params, "organization_id" => organization_id}) do
    with {:ok, %Organization{} = organization} <- Employers.fetch_organization(organization_id),
         vacancy_params = Map.put(vacancy_params, :organization, organization),
         {:ok, %Vacancy{} = vacancy} <- Employers.create_vacancy(vacancy_params) do
      vacancy = Map.put(vacancy, :organization, organization)

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/vacancies/#{vacancy}")
      |> render(:show, vacancy: vacancy)
    end
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
  def show(conn, %{"vacancy_id" => id}) do
    with {:ok, vacancy} <- Employers.fetch_vacancy(id) do
      render(conn, :show, vacancy: vacancy)
    end
  end

  operation :update,
    summary: "Update vacancy",
    parameters: [
      vacancy_id: [in: :path, description: "Vacancy ID", type: :integer, example: "10132"]
    ],
    request_body: {"Vacancy params", "application/json", CreateVacancyRequest},
    responses: [
      created: {"Requested vacancy", "application/json", VacancyResponse},
      unauthorized: "Unauthorized",
      not_found: {"Vacancy not found", "application/json", GenericErrorResponse}
    ]

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t() | {:error, atom()}
  def update(conn, %{"vacancy_id" => id, "vacancy" => vacancy_params}) do
    with {:ok, %{organization: organization} = vacancy} <- Employers.fetch_vacancy(id),
         {:ok, %Vacancy{} = vacancy} <- Employers.update_vacancy(vacancy, vacancy_params) do
      render(conn, :show, vacancy: Map.put(vacancy, :organization, organization))
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
  def delete(conn, %{"vacancy_id" => id}) do
    with {:ok, vacancy} <- Employers.fetch_vacancy(id),
         {:ok, %Vacancy{}} <- Employers.delete_vacancy(vacancy) do
      send_resp(conn, :no_content, "")
    end
  end
end