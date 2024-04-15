defmodule CenWeb.Plugs.ResourceLoader do
  @moduledoc """
  This plug loads resources and assigns them to the connection.

  ## Usage

  Basic usage is as follows:

      plug ResourceLoader, key: :organization, context: Employers, fallback: fallback

  This example utilizes the `key:` option. Refer to the list of options below for more details.

  For more fine-tuning, you can provide your own loader module and its parameters:

      plug ResourceLoader,
        key: :organization,
        fallback: fallback,
        loader_module: ResourceLoader.GenLoader,
        loader_options: [
          resource: {Employers, :fetch_organization},
          param_key: "organization_id"
        ]

  ## Options

    * `key` - required, defines the parameter path name, loader function
              name, and key in `conn.assigns`
    * `fallback` - required, called when an error occurs in the loader
    * `context` - optional, needed for automatically setting fields for the loader
    * `loader` - optional, loader options, by default is uses `CenWeb.Plugs.ResourceLoader.GenLoader`
  """

  import Plug.Conn

  alias CenWeb.Plugs.ResourceLoader.GenLoader

  @type init_params :: {atom(), module(), GenLoader.loader()}

  @spec init(keyword()) :: init_params()
  def init(options) do
    key = Keyword.fetch!(options, :key)
    fallback_module = Keyword.fetch!(options, :fallback)

    context = Keyword.get(options, :context)

    loader_module = Keyword.get(options, :loader_module, GenLoader)

    loader_options =
      options
      |> Keyword.get(:loader, [])
      |> append_param_key(key)
      |> maybe_append_context(context, key)

    loader = init_loader(loader_module, loader_options)

    {key, fallback_module, loader}
  end

  @spec call(Plug.Conn.t(), init_params()) :: Plug.Conn.t()
  def call(conn, {key, fallback_module, loader}) do
    case exec_loader(conn, loader) do
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

  defp init_loader(module, options) do
    loader_init = module.init(options)

    {module, loader_init}
  end

  defp exec_loader(conn, {module, loader_init}) do
    module.load(conn, loader_init)
  end
end
