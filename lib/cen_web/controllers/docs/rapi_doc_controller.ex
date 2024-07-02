defmodule CenWeb.RapiDocController do
  use CenWeb, :controller

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, :rapi_doc, layout: false)
  end
end
