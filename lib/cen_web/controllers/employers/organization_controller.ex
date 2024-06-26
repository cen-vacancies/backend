defmodule CenWeb.OrganizationController do
  use CenWeb, :controller_with_specs

  alias Cen.Accounts
  alias Cen.Employers
  alias Cen.Employers.Organization
  alias CenWeb.Plugs.AccessRules
  alias CenWeb.Plugs.ResourceLoader
  alias CenWeb.Schemas.ChangesetErrorsResponse
  alias CenWeb.Schemas.CreateOrganizationRequest
  alias CenWeb.Schemas.GenericErrorResponse
  alias CenWeb.Schemas.OrganizationResponse
  alias CenWeb.Schemas.Organizations.UpdateOrganizationRequest

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
       [key: :organization, context: Employers, fallback: fallback]
       when action in [:show_by_id]

  plug ResourceLoader,
       [
         fallback: fallback,
         key: :organization,
         loader_module: ResourceLoader.RelativeLoader,
         loader_options: [
           resource: {Employers, :fetch_organization_by_user},
           path: [:current_user]
         ]
       ]
       when action in [:show, :update, :delete]

  plug CenWeb.Plugs.CastAndValidate

  tags :organizations

  operation :show_by_id,
    summary: "Get organization",
    parameters: [
      organization_id: [in: :path, description: "Organization ID", type: :integer, example: "10132"]
    ],
    responses: [
      created: {"Requested organization", "application/json", OrganizationResponse},
      not_found: {"Organization not found", "application/json", GenericErrorResponse},
      unauthorized: {"Unauthorized", "application/json", GenericErrorResponse}
    ]

  @spec show_by_id(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show_by_id(conn, _params) do
    render(conn, :show, organization: fetch_organization(conn))
  end

  security [%{"user_auth" => ["employer"]}]

  operation :show,
    summary: "Get current user's organization",
    responses: [
      created: {"Requested organization", "application/json", OrganizationResponse},
      not_found: {"Organization not found", "application/json", GenericErrorResponse},
      unauthorized: {"Unauthorized", "application/json", GenericErrorResponse}
    ]

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, _params) do
    render(conn, :show, organization: fetch_organization(conn))
  end

  operation :create,
    summary: "Create organization",
    request_body: {"Organization params", "application/json", CreateOrganizationRequest},
    responses: [
      created: {"Created organization", "application/json", OrganizationResponse},
      unprocessable_entity: {"Changeset errors", "application/json", ChangesetErrorsResponse},
      unauthorized: {"Unauthorized", "application/json", GenericErrorResponse},
      forbidden: {"You are not employer", "application/json", GenericErrorResponse}
    ]

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"organization" => organization_params}) do
    employer = conn.assigns.current_user
    organization_params = Map.put(organization_params, :employer, employer)

    with {:ok, %Organization{} = organization} <- Employers.create_organization(organization_params) do
      organization = Map.put(organization, :employer, employer)

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/organization")
      |> render(:show, organization: organization)
    end
  end

  operation :update,
    summary: "Update organization",
    request_body: {"Organization params", "application/json", UpdateOrganizationRequest},
    responses: [
      created: {"Requested organization", "application/json", OrganizationResponse},
      not_found: {"Organization not found", "application/json", GenericErrorResponse},
      unauthorized: {"Unauthorized", "application/json", GenericErrorResponse},
      forbidden: {"You are not the owner", "application/json", GenericErrorResponse}
    ]

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"organization" => organization_params}) do
    updating_result =
      conn
      |> fetch_organization()
      |> Employers.update_organization(organization_params)

    with {:ok, %Organization{} = organization} <- updating_result do
      render(conn, :show, organization: organization)
    end
  end

  operation :delete,
    summary: "Delete organization",
    responses: [
      no_content: "Organization deleted",
      unauthorized: {"Unauthorized", "application/json", GenericErrorResponse},
      forbidden: {"You are not the owner", "application/json", GenericErrorResponse}
    ]

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, _params) do
    conn
    |> fetch_organization()
    |> Employers.delete_organization()

    send_resp(conn, :no_content, "")
  end

  defp fetch_organization(%{assigns: %{organization: organization}}), do: organization
end
