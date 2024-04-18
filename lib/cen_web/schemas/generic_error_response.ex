defmodule CenWeb.Schemas.GenericErrorResponse do
  @moduledoc false

  require CenWeb.StrictAPISchema

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      errors: %{
        type: :object,
        properties: %{
          detail: %{description: "Error reason", type: :string}
        }
      }
    },
    example: %{
      "errors" => %{
        "detail" => "Some error occurred"
      }
    }
  })
end
