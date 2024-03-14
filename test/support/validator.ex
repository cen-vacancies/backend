defmodule CenWeb.Validator do
  @moduledoc false
  import ExUnit.Assertions, only: [assert: 1]

  def assert_schema(schema_module, json) do
    assert {:ok, _value} = OpenApiSpex.Cast.cast(schema_module.schema(), json)
  end
end
