defmodule CenWeb.Plugs.ResourceLoader do
  @moduledoc false
  import Plug.Conn

  alias CenWeb.Plugs.ResourceLoader.GenLoader

  @type init_params :: {atom(), module(), GenLoader.loader()}

  @spec init(keyword()) :: init_params()
  def init(options) do
    key = Keyword.fetch!(options, :key)
    fallback_module = Keyword.fetch!(options, :fallback)
    loader = init_loader(Keyword.fetch!(options, :loader))

    {key, fallback_module, loader}
  end

  @spec call(Plug.Conn.t(), init_params()) :: Plug.Conn.t()
  def call(conn, {key, fallback_module, loader}) do
    case loader.(conn) do
      {:ok, resource} -> assign(conn, key, resource)
      err -> conn |> fallback_module.call(err) |> halt()
    end
  end

  defp init_loader(options) do
    module = Keyword.fetch!(options, :module)

    loader_init = module.init(options)

    fn conn ->
      module.load(conn, loader_init)
    end
  end
end
