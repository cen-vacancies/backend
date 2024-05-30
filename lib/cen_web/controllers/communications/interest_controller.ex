defmodule CenWeb.InterestController do
  use CenWeb, :controller_with_specs

  alias Cen.Communications
  alias CenWeb.Schemas.InterestResponse
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
end
