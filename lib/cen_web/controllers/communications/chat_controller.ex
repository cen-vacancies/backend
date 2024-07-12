defmodule CenWeb.ChatController do
  use CenWeb, :controller_with_specs

  alias Cen.Communications
  alias CenWeb.Schemas.ChatsListResponse

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
      ok: {"Chats list", "application/json", ChatsListResponse}
    ]

  def index(conn, params) do
    user = CenWeb.UserAuth.fetch_current_user(conn)
    page = Communications.get_chats_by_user(user.id, params)

    render(conn, :index, page: page)
  end
end
