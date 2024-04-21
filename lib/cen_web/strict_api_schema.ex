# credo:disable-for-this-file Credo.Check.Readability.Specs
defmodule CenWeb.StrictAPISchema do
  @moduledoc false

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)

      require unquote(__MODULE__)
    end
  end

  def using_properties(%{properties: properties}, options \\ []) do
    properties
    |> using_map(options)
    |> Map.new(fn {key, value} -> {key, to_open_api_spex_schema(value)} end)
  end

  def using_example(%{example: example}, options \\ []) do
    using_map(example, options)
  end

  def using_map(map, options \\ []) do
    only = Keyword.get(options, :only)
    to_add = Keyword.get(options, :add, %{})
    to_remove = Keyword.get(options, :remove, [])

    map
    |> Map.reject(fn {key, _value} -> key in to_remove or (only && key not in only) end)
    |> Map.merge(to_add)
  end

  defmacro schema(api_schema) do
    quote do
      require OpenApiSpex

      unquote(api_schema)
      |> unquote(__MODULE__).set_required()
      |> unquote(__MODULE__).deny_additional_properties()
      |> unquote(__MODULE__).to_open_api_spex_schema()
      |> unquote(__MODULE__).add_nullabe_false()
      |> OpenApiSpex.schema()
    end
  end

  def set_required(api_schema) do
    updated_schema = traverse_schema(api_schema, &set_required/1)

    all_keys =
      api_schema
      |> map_get_thruly(:properties, %{})
      |> Map.keys()

    optional = Map.get(api_schema, :optional, [])

    case optional do
      :all -> Map.put(updated_schema, :required, [])
      _list -> Map.put(updated_schema, :required, all_keys -- optional)
    end
  end

  def deny_additional_properties(%{type: :object} = api_schema) do
    api_schema
    |> traverse_schema(&deny_additional_properties/1)
    |> Map.put_new(:additionalProperties, false)
  end

  def deny_additional_properties(%{type: _other} = api_schema) do
    api_schema
  end

  def to_open_api_spex_schema(%OpenApiSpex.Schema{} = value) do
    value
  end

  def to_open_api_spex_schema(api_schema) do
    updated_schema = traverse_schema(api_schema, &to_open_api_spex_schema/1)
    struct(OpenApiSpex.Schema, updated_schema)
  end

  def add_nullabe_false(api_schema) do
    Map.put_new(api_schema, :nullable, false)
  end

  defp map_update_thruly(map, key, fun) do
    case Map.fetch(map, key) do
      :error -> map
      {:ok, nil} -> map
      {:ok, value} -> Map.put(map, key, fun.(value))
    end
  end

  defp map_get_thruly(map, key, default) do
    case Map.fetch(map, key) do
      :error -> default
      {:ok, nil} -> default
      {:ok, value} -> value
    end
  end

  defp traverse_schema(api_schema, fun) do
    api_schema
    |> map_update_thruly(:properties, fn
      properties ->
        Map.new(properties, fn {key, value} ->
          {key, fun.(value)}
        end)
    end)
    |> map_update_thruly(:items, fn
      value -> fun.(value)
    end)
  end
end
