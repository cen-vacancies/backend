defmodule CenWeb.Schemas.UserCredentials do
  @moduledoc false

  require CenWeb.StrictAPISchema

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      user: %{
        type: :object,
        properties: %{
          email: %{type: :string},
          password: %{type: :string}
        }
      }
    },
    example: %{
      "user" => %{
        "password" => "123456qwerty",
        "email" => "username@domain.org"
      }
    }
  })
end
