defmodule CenWeb.AdminScope.OrganizationController do
  use CenWeb, :controller_with_specs

  alias CenWeb.Schemas.OrganizationsListResponse

  plug CenWeb.Plugs.CastAndValidate

  tags "admin_organizastions"

  security [%{"user_auth" => []}]

  operation :index,
    summary: "Get list of organizations",
    parameters: [
      page: [in: :query, description: "Page number", type: :integer],
      page_size: [in: :query, description: "Page size", type: :integer]
    ],
    responses: [
      ok: {"Organizations list", "application/json", OrganizationsListResponse}
    ]

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    render(conn, :index, page: Cen.Employers.list_organizations(params))
  end
end
