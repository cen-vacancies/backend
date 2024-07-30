defmodule CenWeb.AdminScope.UserController do
  use CenWeb, :controller_with_specs

  alias Cen.Accounts
  alias CenWeb.Plugs.ResourceLoader
  alias CenWeb.Schemas.ChangesetErrorsResponse
  alias CenWeb.Schemas.UpdateUserRequest
  alias CenWeb.Schemas.UserResponse
  alias CenWeb.Schemas.UsersListResponse

  fallback = CenWeb.FallbackController
  action_fallback fallback

  plug CenWeb.Plugs.CastAndValidate

  plug ResourceLoader,
       [key: :user, context: Accounts, fallback: fallback]
       when action in [:update, :delete]

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

  operation :update,
    summary: "Update user",
    request_body: {"User params", "application/json", UpdateUserRequest},
    responses: [
      ok: {"Updated user", "application/json", UserResponse},
      unprocessable_entity: {"Changeset errors", "application/json", ChangesetErrorsResponse}
    ]

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t() | {:error, atom()}
  def update(conn, %{"user" => user_info}) do
    updating_result =
      conn
      |> fetch_user()
      |> Accounts.update_user(user_info)

    with {:ok, updated_user} <- updating_result do
      render(conn, :show, user: updated_user)
    end
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
