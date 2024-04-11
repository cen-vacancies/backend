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
        |> CenWeb.FallbackController.call({:error, :unauthorized})
        |> halt()
    end
  end

  @spec fetch_current_user(Plug.Conn.t()) :: Accounts.User.t()
  def fetch_current_user(%{assigns: %{current_user: current_user}}), do: current_user
end
