defmodule CenWeb.TokenController do
  use CenWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Cen.Accounts
  alias CenWeb.Schemas.TokenResponse
  alias CenWeb.Schemas.UserCredentials

  action_fallback CenWeb.FallbackController

  tags "authorization[DRAFT]"

  operation :create,
    summary: "Get access token",
    request_body: {"credentials", "application/json", UserCredentials},
    responses: [
      ok: {"User's token", "application/json", TokenResponse},
      unauthorized: "Wrong email or password"
    ]

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.get_user_by_email_and_password(email, password) do
      nil ->
        send_resp(conn, :unauthorized, "")

      user ->
        token = Accounts.create_user_api_token(user)
        render(conn, :show, token: token)
    end
  end
end
