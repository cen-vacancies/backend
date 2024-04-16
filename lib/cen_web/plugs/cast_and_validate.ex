defmodule CenWeb.Plugs.CastAndValidate do
  @moduledoc false
  @behaviour Plug

  alias CenWeb.Plugs.RequestErrorRendererPlug
  alias OpenApiSpex.Plug.CastAndValidate

  @cen_defaults [
    json_render_error_v2: true,
    replace_params: false,
    render_error: RequestErrorRendererPlug
  ]

  @impl Plug
  def init(opts) do
    @cen_defaults
    |> Keyword.merge(opts)
    |> CastAndValidate.init()
  end

  @impl Plug
  def call(conn, opts) do
    conn
    |> to_query_arrays()
    |> CastAndValidate.call(opts)
  end

  defp to_query_arrays(conn) do
    Map.update!(
      conn,
      :query_params,
      &Map.new(&1, fn
        {key, value} when is_list(value) -> {key <> "[]", value}
        pair -> pair
      end)
    )
  end
end
