defmodule CenWeb.CVController do
  use CenWeb, :controller_with_specs

  alias Cen.Accounts
  alias Cen.Applicants
  alias Cen.Applicants.CV
  alias CenWeb.Plugs.AccessRules
  alias CenWeb.Plugs.ResourceLoader
  alias CenWeb.Schemas.ChangesetErrorsResponse
  alias CenWeb.Schemas.CreateCVRequest
  alias CenWeb.Schemas.CVResponse
  alias CenWeb.Schemas.GenericErrorResponse
  alias CenWeb.Schemas.UpdateCVRequest

  fallback = CenWeb.FallbackController
  action_fallback fallback

  plug ResourceLoader,
       [key: :cv, context: Applicants, fallback: fallback]
       when action in [:show, :update, :delete]

  plug AccessRules,
       [
         fallback: fallback,
         verify_fun: &Accounts.has_applicant_permissions?/1,
         args_keys: [:current_user],
         reason: "You are not the applicant"
       ]
       when action in [:create]

  plug AccessRules,
       [
         fallback: fallback,
         verify_fun: &Applicants.can_user_edit_cv?/2,
         args_keys: [:cv, :current_user],
         reason: "You are not the owner"
       ]
       when action in [:update, :delete]

  plug CenWeb.Plugs.CastAndValidate

  security [%{}, %{"user_auth" => ["applicant"]}]

  tags :cvs

  operation :create,
    summary: "Create CV",
    request_body: {"CV params", "application/json", CreateCVRequest},
    responses: [
      created: {"Created CV", "application/json", CVResponse},
      unprocessable_entity: {"Changeset errors", "application/json", ChangesetErrorsResponse},
      unauthorized: {"Unauthorized", "application/json", GenericErrorResponse},
      forbidden: {"You are not employer", "application/json", GenericErrorResponse}
    ]

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"cv" => cv_params}) do
    applicant = CenWeb.UserAuth.fetch_current_user(conn)
    cv_params = Map.put(cv_params, :applicant, applicant)

    with {:ok, %CV{} = cv} <- Applicants.create_cv(cv_params) do
      cv = Map.put(cv, :applicant, applicant)

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/cvs/#{cv}")
      |> render(:show, cv: cv)
    end
  end

  operation :show,
    summary: "Get CV",
    parameters: [
      cv_id: [in: :path, description: "CV ID", type: :integer, example: "10132"]
    ],
    responses: [
      ok: {"Requested CV", "application/json", CVResponse},
      not_found: {"CV not found", "application/json", GenericErrorResponse},
      unauthorized: {"Unauthorized", "application/json", GenericErrorResponse}
    ]

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, _params) do
    cv = get_cv(conn)
    render(conn, :show, cv: cv)
  end

  operation :update,
    summary: "Update CV",
    parameters: [
      cv_id: [in: :path, description: "CV ID", type: :integer, example: "10132"]
    ],
    request_body: {"CV params", "application/json", UpdateCVRequest},
    responses: [
      created: {"Requested CV", "application/json", CVResponse},
      not_found: {"CV not found", "application/json", GenericErrorResponse},
      unauthorized: {"Unauthorized", "application/json", GenericErrorResponse},
      forbidden: {"You are not the owner", "application/json", GenericErrorResponse}
    ]

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"cv" => cv_params}) do
    applicant = CenWeb.UserAuth.fetch_current_user(conn)
    cv = get_cv(conn)

    with {:ok, %CV{} = cv} <- Applicants.update_cv(cv, cv_params) do
      cv = Map.put(cv, :applicant, applicant)

      render(conn, :show, cv: cv)
    end
  end

  operation :delete,
    summary: "Delete CV",
    parameters: [
      cv_id: [in: :path, description: "CV ID", type: :integer, example: "10132"]
    ],
    responses: [
      no_content: "CV deleted",
      unauthorized: {"Unauthorized", "application/json", GenericErrorResponse},
      forbidden: {"You are not the owner", "application/json", GenericErrorResponse}
    ]

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, _params) do
    cv = get_cv(conn)

    with {:ok, %CV{}} <- Applicants.delete_cv(cv) do
      send_resp(conn, :no_content, "")
    end
  end

  defp get_cv(%{assigns: %{cv: cv}}), do: cv
end
