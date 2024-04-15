defmodule CenWeb.Plugs.ResourceLoader.GenLoader do
  @moduledoc """
  Simply call the load function.

  ## Options

    * `resource` - a tuple containing the module and function to call
    * `param_key` - the key for path parameters, the default is `"id"`
  """

  @type loader :: {module, keyword()}

  @spec init(keyword()) :: loader
  def init(opts) do
    {context, fun} = Keyword.fetch!(opts, :resource)
    param_key = Keyword.get(opts, :param_key, "id")

    {context, fun, param_key}
  end

  @spec load(Plug.Conn.t(), loader) :: Plug.Conn.t()
  def load(conn, loader) do
    exec_loader(conn, loader)
  end

  defp exec_loader(conn, {context, fun, param_key}) do
    apply(context, fun, [conn.params[param_key]])
  end
end
