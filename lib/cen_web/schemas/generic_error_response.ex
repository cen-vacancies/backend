defmodule CenWeb.Schemas.GenericErrorResponse do
  @moduledoc false
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Error",
    type: :object,
    required: ~w[errors]a,
    properties: %{
      errors: %Schema{
        type: :object,
        required: ~w[detail]a,
        properties: %{
          detail: %Schema{title: "Error reason", type: :string}
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
