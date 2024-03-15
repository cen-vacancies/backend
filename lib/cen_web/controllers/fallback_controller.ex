# credo:disable-for-this-file Credo.Check.Readability.Specs
defmodule CenWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use CenWeb, :controller

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: CenWeb.ErrorHTML, json: CenWeb.ErrorJSON)
    |> render(:"404")
  end
end
