defmodule CenWeb.AdminScope.VacancyController do
  use CenWeb, :controller_with_specs

  alias CenWeb.Schemas.VacanciesListResponse

  plug CenWeb.Plugs.CastAndValidate

  tags "admin_publications"

  security [%{"user_auth" => []}]

  operation :index_unreviewed,
    summary: "Get list of unreviewed vacancies",
    parameters: [
      page: [in: :query, description: "Page number", type: :integer],
      page_size: [in: :query, description: "Page size", type: :integer]
    ],
    responses: [
      ok: {"Vacancies list", "application/json", VacanciesListResponse}
    ]

  @spec index_unreviewed(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index_unreviewed(conn, params) do
    render(conn, :index, page: Cen.Employers.list_unreviewed_vacancies(params))
  end
end
