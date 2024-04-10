# credo:disable-for-this-file Credo.Check.Readability.Specs
defmodule CenWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use CenWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(html: CenWeb.ErrorHTML, json: CenWeb.ChangesetJSON)
    |> render("error.json", %{changeset: changeset})
  end

  def call(conn, {:error, reason}) do
    conn
    |> put_status(reason)
    |> put_view(html: CenWeb.ErrorHTML, json: CenWeb.ErrorJSON)
    |> render(reason)
  end
end
