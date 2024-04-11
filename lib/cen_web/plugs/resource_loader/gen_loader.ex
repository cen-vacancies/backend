defmodule CenWeb.Plugs.ResourceLoader.GenLoader do
  @moduledoc false

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
