defmodule CenWeb.Schemas.UserCredentials do
  @moduledoc false
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "User's credentials",
    type: :object,
    required: ~w[user]a,
    properties: %{
      user: %Schema{
        type: :object,
        required: ~w[email password]a,
        properties: %{
          email: %Schema{type: :string},
          password: %Schema{type: :string}
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
