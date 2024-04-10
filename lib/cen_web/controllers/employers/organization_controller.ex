defmodule CenWeb.OrganizationController do
  use CenWeb, :controller_with_specs

  alias Cen.Accounts
  alias Cen.Employers
  alias Cen.Employers.Organization
  alias CenWeb.Plugs.AccessRules
  alias CenWeb.Plugs.ResourceLoader
  alias CenWeb.Schemas.ChangesetErrorsResponse
  alias CenWeb.Schemas.CreateOrganizationRequest
  alias CenWeb.Schemas.NotFoundErrorResponse
  alias CenWeb.Schemas.OrganizationResponse

  fallback = CenWeb.FallbackController
  action_fallback fallback

  plug ResourceLoader,
       [
         key: :organization,
         fallback: fallback,
         loader: [
           module: ResourceLoader.GenLoader,
           resource: {Employers, :fetch_organization},
           param_key: "organization_id"
         ]
       ]
       when action in [:show, :update, :delete]

  plug AccessRules,
       [
         fallback: fallback,
         verify_fun: &Accounts.can_user_create_organization?/1,
         args_keys: [:current_user]
       ]
       when action in [:create]

  plug AccessRules,
       [
         fallback: fallback,
         verify_fun: &Employers.can_user_edit?/2,
         args_keys: [:organization, :current_user]
       ]
       when action in [:update, :delete]

  security [%{}, %{"user_auth" => ["employer"]}]

  tags :organizations

  operation :create,
    summary: "Create organization",
    request_body: {"Organization params", "application/json", CreateOrganizationRequest},
    responses: [
      created: {"Created organization", "application/json", OrganizationResponse},
      unauthorized: "Unauthorized",
      unprocessable_entity: {"Changeset errors", "application/json", ChangesetErrorsResponse}
    ]

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"organization" => organization_params}) do
    employer = conn.assigns.current_user
    organization_params = Map.put(organization_params, :employer, employer)

    with {:ok, %Organization{} = organization} <- Employers.create_organization(organization_params) do
      organization = Map.put(organization, :employer, employer)

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/organizations/#{organization}")
      |> render(:show, organization: organization)
    end
  end

  operation :show,
    summary: "Get organization",
    parameters: [
      organization_id: [in: :path, description: "Organization ID", type: :integer, example: "10132"]
    ],
    responses: [
      created: {"Requested organization", "application/json", OrganizationResponse},
      unauthorized: "Unauthorized",
      not_found: {"Organization not found", "application/json", NotFoundErrorResponse}
    ]

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, _params) do
    render(conn, :show, organization: fetch_organization(conn))
  end

  operation :update,
    summary: "Update organization",
    parameters: [
      organization_id: [in: :path, description: "Organization ID", type: :integer, example: "10132"]
    ],
    request_body: {"Organization params", "application/json", CreateOrganizationRequest},
    responses: [
      created: {"Requested organization", "application/json", OrganizationResponse},
      unauthorized: "Unauthorized",
      not_found: {"Organization not found", "application/json", NotFoundErrorResponse}
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
    parameters: [
      organization_id: [in: :path, description: "Organization ID", type: :integer, example: "10132"]
    ],
    responses: [
      no_content: "Organization deleted",
      unauthorized: "Unauthorized"
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