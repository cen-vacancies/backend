defmodule CenWeb.AdminScope.UserController do
  use CenWeb, :controller_with_specs

  alias Cen.Accounts
  alias CenWeb.Plugs.ResourceLoader
  alias CenWeb.Schemas.UsersListResponse

  fallback = CenWeb.FallbackController
  action_fallback fallback

  plug CenWeb.Plugs.CastAndValidate

  plug ResourceLoader,
       [key: :user, context: Accounts, fallback: fallback]
       when action in [:delete]

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

  operation :delete,
    summary: "Delete user",
    responses: [
      no_content: "User deleted"
    ]

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, _params) do
    conn
    |> fetch_user()
    |> Accounts.delete_user()

    send_resp(conn, :no_content, "")
  end

  defp fetch_user(%{assigns: %{user: user}}), do: user
end
