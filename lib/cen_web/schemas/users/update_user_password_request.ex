defmodule CenWeb.Schemas.UpdateUserPasswordRequest do
  @moduledoc false

  use CenWeb.StrictAPISchema

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      user: %{
        type: :object,
        properties: %{
          current_password: %{type: :string},
          password: %{type: :string}
        }
      }
    },
    example: %{
      "user" => %{
        "current_password" => "123456qwerty",
        "password" => "qwerty123456"
      }
    }
  })
end
