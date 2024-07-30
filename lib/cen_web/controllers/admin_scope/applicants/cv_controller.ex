defmodule CenWeb.AdminScope.CVController do
  use CenWeb, :controller_with_specs

  alias CenWeb.Schemas.CVsListResponse

  plug CenWeb.Plugs.CastAndValidate

  tags "admin_publications"

  security [%{"user_auth" => []}]

  operation :index_unreviewed,
    summary: "Get list of unreviewed CVs",
    parameters: [
      page: [in: :query, description: "Page number", type: :integer],
      page_size: [in: :query, description: "Page size", type: :integer]
    ],
    responses: [
      ok: {"CVs list", "application/json", CVsListResponse}
    ]

  @spec index_unreviewed(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index_unreviewed(conn, params) do
    render(conn, :index, page: Cen.Applicants.list_unreviewed_cvs(params))
  end
end
