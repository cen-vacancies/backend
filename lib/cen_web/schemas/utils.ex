defmodule CenWeb.Schemas.Utils do
  @moduledoc false

  alias CenWeb.Schemas.Page

  @spec list_of(module()) :: map()
  def list_of(schema_mod) do
    %{
      type: :object,
      properties: %{
        data: %{
          type: :array,
          items: schema_mod.schema()
        },
        page: Page.schema()
      },
      example: %{
        "data" => [schema_mod.schema().example],
        "page" => Page.schema().example
      }
    }
  end
end
