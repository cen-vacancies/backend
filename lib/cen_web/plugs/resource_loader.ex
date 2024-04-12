defmodule CenWeb.Plugs.ResourceLoader do
  @moduledoc ~S"""
  This plug loads resource and put to conn assigns.

  ## Using
  Basic is:

      plug ResourceLoader, key: :organization, context: Employers, fallback: fallback

  This example uses the `key:` parameter to define the parameter path name,
  loader function name, and key in `conn.assigns`

  For more fine-tuning, you can pass your own loader module and its parameters:

      plug ResourceLoader,
        key: :organization,
        fallback: fallback,
        loader: [
          module: ResourceLoader.GenLoader,
          resource: {Employers, :fetch_organization},
          param_key: "organization_id"
        ]
  """
  import Plug.Conn

  alias CenWeb.Plugs.ResourceLoader.GenLoader

  @type init_params :: {atom(), module(), GenLoader.loader()}

  @spec init(keyword()) :: init_params()
  def init(options) do
    key = Keyword.fetch!(options, :key)
    fallback_module = Keyword.fetch!(options, :fallback)

    context = Keyword.get(options, :context)

    loader_options =
      options
      |> Keyword.get(:loader, [])
      |> append_param_key(key)
      |> maybe_append_context(context, key)

    loader = init_loader(loader_options)

    {key, fallback_module, loader}
  end

  @spec call(Plug.Conn.t(), init_params()) :: Plug.Conn.t()
  def call(conn, {key, fallback_module, loader}) do
    case loader.(conn) do
      {:ok, resource} -> assign(conn, key, resource)
      err -> conn |> fallback_module.call(err) |> halt()
    end
  end

  defp append_param_key(options, key), do: Keyword.put_new(options, :param_key, "#{key}_id")

  defp maybe_append_context(options, nil, _key), do: options

  defp maybe_append_context(options, context, key) do
    function_name = String.to_existing_atom("fetch_#{key}")

    Keyword.put_new(options, :resource, {context, function_name})
  end

  defp init_loader(options) do
    module = Keyword.get(options, :module, GenLoader)

    loader_init = module.init(options)

    fn conn ->
      module.load(conn, loader_init)
    end
  end
end
