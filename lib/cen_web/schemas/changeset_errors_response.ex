defmodule CenWeb.Schemas.ChangesetErrorsResponse do
  @moduledoc false

  use CenWeb.StrictAPISchema

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      errors: %{
        type: :object,
        additionalProperties: true,
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
