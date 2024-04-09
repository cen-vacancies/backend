defmodule CenWeb.Schemas.NotFoundErrorResponse do
  @moduledoc false
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Resource not found",
    type: :object,
    required: ~w[errors]a,
    properties: %{
      errors: %Schema{
        type: :object,
        properties: %{
          detail: %Schema{
            type: :string,
            format: "Not Found"
          }
        }
      }
    },
    example: %{
      "errors" => %{
        "detail" => "Not Found"
      }
    }
  })
end
