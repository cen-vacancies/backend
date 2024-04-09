defmodule CenWeb.UserAuth do
  @moduledoc false
  use CenWeb, :verified_routes

  import Plug.Conn

  alias Cen.Accounts

  @spec fetch_api_user(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def fetch_api_user(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, user, claims} <- Accounts.fetch_user_by_api_token(token) do
      conn
      |> assign(:current_user, user)
      |> assign(:current_user_claims, claims)
    else
      _error ->
        conn
        |> send_resp(:unauthorized, "No access for you")
        |> halt()
    end
  end
end
