defmodule CenWeb.AdminScope.UserController do
  use CenWeb, :controller_with_specs

  alias Cen.Accounts
  alias CenWeb.Schemas.UsersListResponse

  fallback = CenWeb.FallbackController
  action_fallback fallback

  plug CenWeb.Plugs.CastAndValidate

  tags "admin_users"

  security [%{"user_auth" => []}]

  operation :index,
    summary: "Get list of users",
    parameters: [
      page: [in: :query, description: "Page number", type: :integer],
      page_size: [in: :query, description: "Page size", type: :integer]
    ],
    responses: [
      ok: {"Requested user", "application/json", UsersListResponse}
    ]

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    render(conn, :index, page: Accounts.list_users(params))
  end
end
