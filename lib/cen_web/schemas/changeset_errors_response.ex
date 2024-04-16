defmodule CenWeb.Schemas.ChangesetErrorsResponse do
  @moduledoc false
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "ChangesetErrorsResponse",
    type: :object,
    required: ~w[errors]a,
    properties: %{
      errors: %Schema{
        type: :object,
        description: "Errors map. Keys are fields and values are array of errors"
      }
    },
    example: %{
      "errors" => %{
        "password" => ["too short"]
      }
    }
  })
end
