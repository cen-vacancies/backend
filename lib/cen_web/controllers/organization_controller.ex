defmodule CenWeb.OrganizationController do
  use CenWeb, :controller

  alias Cen.Employers
  alias Cen.Employers.Organization
  alias CenWeb.Schemas.ChangesetErrorsResponse
  alias CenWeb.Schemas.CreateOrganizationRequest
  alias CenWeb.Schemas.NotFoundErrorResponse
  alias CenWeb.Schemas.OrganizationResponse

  action_fallback CenWeb.FallbackController

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

  def create(conn, %{"organization" => organization_params}) do
    employer = conn.assigns.current_user
    organization_params = Map.put(organization_params, :employer, employer)

    with {:ok, %Organization{} = organization} <- Employers.create_organization(organization_params) do
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

  def show(conn, %{"organization_id" => id}) do
    with {:ok, organization} <- Employers.fetch_organization(id) do
      render(conn, :show, organization: organization)
    end
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

  def update(conn, %{"organization_id" => id, "organization" => organization_params}) do
    with {:ok, organization} <- Employers.fetch_organization(id),
         {:ok, %Organization{} = organization} <- Employers.update_organization(organization, organization_params) do
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

  def delete(conn, %{"organization_id" => id}) do
    with {:ok, organization} <- Employers.fetch_organization(id) do
      Employers.delete_organization(organization)
    end

    send_resp(conn, :no_content, "")
  end
end
