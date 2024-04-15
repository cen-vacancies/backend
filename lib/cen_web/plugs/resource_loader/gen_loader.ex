defmodule CenWeb.Plugs.ResourceLoader.GenLoader do
  @moduledoc """
  Simply call the load function.

  ## Options

    * `resource` - a tuple containing the module and function to call
    * `param_key` - the key for path parameters, the default is `"id"`
  """

  @type loader :: (Plug.Conn.t() -> Plug.Conn.t())

  @spec init(keyword()) :: loader
  def init(opts) do
    {context, fun} = Keyword.fetch!(opts, :resource)
    param_key = Keyword.get(opts, :param_key, "id")

    fn conn ->
      apply(context, fun, [conn.params[param_key]])
    end
  end

  @spec load(Plug.Conn.t(), loader) :: Plug.Conn.t()
  def load(conn, load_fun) do
    load_fun.(conn)
  end
end
