defmodule CenWeb.ChatDevController do
  use CenWeb, :controller

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, :chat, layout: false)
  end
end
