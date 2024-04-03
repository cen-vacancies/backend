defmodule CenWeb.UserController do
  use CenWeb, :controller

  alias Cen.Accounts
  alias CenWeb.Schemas.ChangesetErrorsResponse
  alias CenWeb.Schemas.CreateUserRequest
  alias CenWeb.Schemas.NotFoundErrorResponse
  alias CenWeb.Schemas.UserResponse

  action_fallback CenWeb.FallbackController

  tags "users"

  operation :create,
    summary: "Create user",
    request_body: {"User params", "application/json", CreateUserRequest},
    responses: [
      ok: {"Created user", "application/json", UserResponse},
      unprocessable_entity: {"Changeset errors", "application/json", ChangesetErrorsResponse}
    ]

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.register_user(user_params) do
      render(conn, :show, user: user)
    end
  end

  operation :show,
    summary: "Get user by ID",
    parameters: [
      user_id: [in: :path, description: "User ID", type: :integer, example: "10132"]
    ],
    responses: [
      ok: {"Requested user", "application/json", UserResponse},
      not_found: {"User not found", "application/json", NotFoundErrorResponse}
    ]

  def show(conn, %{"user_id" => user_id}) do
    with {:ok, user} <- Accounts.fetch_user(user_id) do
      render(conn, :show, user: user)
    end
  end

  operation :update_info,
    summary: "Update user",
    parameters: [
      user_id: [in: :path, description: "User ID", type: :string, example: "f3e99641-3214-431a-8d46-26cb4c2efee9"]
    ],
    request_body: {"User params", "application/json", CreateUserRequest},
    responses: [
      ok: {"Updated user", "application/json", UserResponse},
      not_found: {"User not found", "application/json", NotFoundErrorResponse},
      unprocessable_entity: {"Changeset errors", "application/json", ChangesetErrorsResponse}
    ]

  def update_info(conn, %{"user_id" => user_id, "user" => user_info}) do
    with {:ok, user} <- Accounts.fetch_user(user_id),
         {:ok, updated_user} <- Accounts.update_user_info(user, user_info) do
      render(conn, :show, user: updated_user)
    end
  end

  operation :delete,
    summary: "Delete user",
    parameters: [
      user_id: [in: :path, description: "User ID", type: :string, example: "f3e99641-3214-431a-8d46-26cb4c2efee9"]
    ],
    responses: [
      no_content: "User deleted"
    ]

  def delete(conn, %{"user_id" => user_id}) do
    with {:ok, user} <- Accounts.fetch_user(user_id) do
      Accounts.delete_user(user)
    end

    send_resp(conn, :no_content, "")
  end
end
