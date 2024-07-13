defmodule CenWeb.ChatController do
  use CenWeb, :controller_with_specs

  alias Cen.Communications
  alias CenWeb.Schemas.ChangesetErrorsResponse
  alias CenWeb.Schemas.ChatsListResponse
  alias CenWeb.Schemas.MessageResponse
  alias CenWeb.Schemas.SendMessageRequest

  action_fallback CenWeb.FallbackController

  plug CenWeb.Plugs.CastAndValidate

  tags :chats
  security [%{"user_auth" => []}]

  operation :index,
    summary: "Get all user's chats",
    parameters: [
      page: [in: :query, description: "Page number", type: :integer],
      page_size: [in: :query, description: "Page size", type: :integer]
    ],
    responses: [
      ok: {"Chats list", "application/json", ChatsListResponse},
      unprocessable_entity: {"Changeset errors", "application/json", ChangesetErrorsResponse}
    ]

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    user = CenWeb.UserAuth.fetch_current_user(conn)
    page = Communications.get_chats_by_user(user.id, params)

    render(conn, :index, page: page)
  end

  operation :send_message,
    summary: "Send message",
    request_body: {"Message params", "application/json", SendMessageRequest},
    responses: [
      ok: {"Chats list", "application/json", MessageResponse},
      unprocessable_entity: {"Changeset errors", "application/json", ChangesetErrorsResponse}
    ]

  @spec send_message(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def send_message(conn, %{"cv_id" => cv_id, "vacancy_id" => vacancy_id} = params) do
    user = CenWeb.UserAuth.fetch_current_user(conn)

    with {:ok, message} <- Communications.create_message(user.id, cv_id, vacancy_id, params) do
      render(conn, :show_message, message: message)
    end
  end
end
