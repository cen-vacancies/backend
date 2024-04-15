defmodule CenWeb.Plugs.ResourceLoader.GenLoader do
  @moduledoc """
  Simply call the load function.

  ## Options

    * `resource` - a tuple containing the module and function to call
    * `param_key` - the key for path parameters, the default is `"id"`
  """

  @type loader :: {module(), atom(), keyword()}

  @spec init(keyword()) :: loader
  def init(opts) do
    {context, fun_name} = Keyword.fetch!(opts, :resource)
    param_key = Keyword.get(opts, :param_key, "id")

    {context, fun_name, param_key}
  end

  @spec load(Plug.Conn.t(), loader) :: Plug.Conn.t()
  def load(conn, loader) do
    exec_loader(conn, loader)
  end

  defp exec_loader(conn, {context, fun_name, param_key}) do
    apply(context, fun_name, [conn.params[param_key]])
  end
end
