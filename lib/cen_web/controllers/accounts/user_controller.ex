defmodule CenWeb.UserController do
  use CenWeb, :controller_with_specs

  alias Cen.Accounts
  alias CenWeb.Schemas.ChangesetErrorsResponse
  alias CenWeb.Schemas.CreateUserRequest
  alias CenWeb.Schemas.UpdateUserInfoRequest
  alias CenWeb.Schemas.UserResponse
  alias CenWeb.UserAuth

  plug CenWeb.Plugs.CastAndValidate

  action_fallback CenWeb.FallbackController

  tags "users"

  operation :create,
    summary: "Create user",
    request_body: {"User params", "application/json", CreateUserRequest},
    responses: [
      ok: {"Created user", "application/json", UserResponse},
      unprocessable_entity: {"Changeset errors", "application/json", ChangesetErrorsResponse}
    ]

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.register_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/me")
      |> render(:show, user: user)
    end
  end

  operation :show,
    summary: "Get user by ID",
    responses: [
      ok: {"Requested user", "application/json", UserResponse}
    ]

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, _params) do
    render(conn, :show, user: UserAuth.fetch_current_user(conn))
  end

  operation :update_info,
    summary: "Update user",
    request_body: {"User params", "application/json", UpdateUserInfoRequest},
    responses: [
      ok: {"Updated user", "application/json", UserResponse},
      unprocessable_entity: {"Changeset errors", "application/json", ChangesetErrorsResponse}
    ]

  @spec update_info(Plug.Conn.t(), map()) :: Plug.Conn.t() | {:error, atom()}
  def update_info(conn, %{"user" => user_info}) do
    updating_result =
      conn
      |> UserAuth.fetch_current_user()
      |> Accounts.update_user_info(user_info)

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
    |> UserAuth.fetch_current_user()
    |> Accounts.delete_user()

    send_resp(conn, :no_content, "")
  end
end
