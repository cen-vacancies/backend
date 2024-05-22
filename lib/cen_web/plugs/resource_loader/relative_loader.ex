defmodule CenWeb.Plugs.ResourceLoader.RelativeLoader do
  @moduledoc false

  @type loader :: {module(), atom(), [atom()]}

  @spec init(keyword()) :: loader
  def init(opts) do
    {context, fun_name} = Keyword.fetch!(opts, :resource)
    path = Keyword.fetch!(opts, :path)

    {context, fun_name, path}
  end

  @spec load(Plug.Conn.t(), loader) :: Plug.Conn.t()
  def load(conn, loader) do
    exec_loader(conn, loader)
  end

  defp exec_loader(conn, {context, fun_name, path}) do
    arg = fetch_path!(conn.assigns, path)
    apply(context, fun_name, [arg])
  end

  defp fetch_path!(map, path)
  defp fetch_path!(map, [key]), do: Map.fetch!(map, key)
  defp fetch_path!(map, [key | path]), do: map |> Map.fetch!(key) |> fetch_path!(path)
end
