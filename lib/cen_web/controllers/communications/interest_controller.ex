defmodule CenWeb.InterestController do
  use CenWeb, :controller_with_specs

  alias Cen.Communications
  alias CenWeb.Schemas.InterestResponse
  alias CenWeb.Schemas.InterestsListResponse
  alias CenWeb.Schemas.SendInterestRequest
  alias CenWeb.UserAuth

  plug CenWeb.Plugs.CastAndValidate

  action_fallback CenWeb.FallbackController

  tags "interest"

  security [%{"user_auth" => []}]

  operation :send_interest,
    summary: "Send interest to vacancy or CV",
    request_body: {"credentials", "application/json", SendInterestRequest},
    responses: [
      ok: {"Interest", "application/json", InterestResponse}
    ]

  @spec send_interest(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def send_interest(conn, %{"cv_id" => cv_id, "vacancy_id" => vacancy_id}) do
    user = UserAuth.fetch_current_user(conn)

    with {:ok, interest} <- Communications.send_interest(user.role, cv_id, vacancy_id) do
      render(conn, :show, interest: Communications.get_interest!(interest.id))
    end
  end

  operation :unsend_interest,
    summary: "Unsend interest to vacancy or CV",
    request_body: {"credentials", "application/json", SendInterestRequest},
    responses: [
      no_content: "User deleted"
    ]

  @spec unsend_interest(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def unsend_interest(conn, %{"cv_id" => cv_id, "vacancy_id" => vacancy_id}) do
    Communications.unsend_interest(cv_id, vacancy_id)

    send_resp(conn, :no_content, "")
  end

  operation :index,
    summary: "Get list of interests",
    parameters: [
      type: [
        in: :query,
        required: true,
        schema: %OpenApiSpex.Schema{type: :string, enum: ~w[sended recieved]}
      ],
      page: [in: :query, description: "Page number", type: :integer],
      page_size: [in: :query, description: "Page size", type: :integer]
    ],
    responses: [
      ok: {"Interest", "application/json", InterestsListResponse}
    ]

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    user = UserAuth.fetch_current_user(conn)

    page = Communications.list_interests(user.id, user.role, params["type"], params)

    render(conn, :index, page: page)
  end
end
