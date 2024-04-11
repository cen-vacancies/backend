# credo:disable-for-this-file Credo.Check.Readability.Specs
defmodule CenWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use CenWeb, :controller

  alias Plug.Conn.Status

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(html: CenWeb.ErrorHTML, json: CenWeb.ChangesetJSON)
    |> render("error.json", %{changeset: changeset})
  end

  def call(conn, {:error, :forbidden, reason}) do
    conn
    |> put_status(:forbidden)
    |> put_view(html: CenWeb.ErrorHTML, json: CenWeb.ErrorJSON)
    |> render(:forbidden, reason: reason)
  end

  def call(conn, {:error, reason}) do
    template =
      reason
      |> Status.code()
      |> Integer.to_string()
      # It's safe, because of `Status.code/1`, which works only with HTTP status
      # codes (which are finite and well-defined). Otherwise it raises error.
      #
      # So, there's no atom exhaustion.
      #
      # credo:disable-for-lines:2 Credo.Check.Warning.UnsafeToAtom
      # sobelow_skip ["DOS.StringToAtom"]
      |> String.to_atom()

    conn
    |> put_status(reason)
    |> put_view(html: CenWeb.ErrorHTML, json: CenWeb.ErrorJSON)
    |> render(template)
  end
end
