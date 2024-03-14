defmodule CenWeb.SchemasTest do
  use ExUnit.Case

  import CenWeb.Validator

  with {:ok, modules} <- :application.get_key(:cen, :modules) do
    for module <- modules, match?(["CenWeb", "Schemas" | _rest], Module.split(module)) do
      ["CenWeb", "Schemas" | shortname_list] = Module.split(module)
      shortname = Enum.join(shortname_list, ".")

      test "#{shortname} example matches schema" do
        module = unquote(module)
        assert_schema module, module.schema().example
      end
    end
  end
end
