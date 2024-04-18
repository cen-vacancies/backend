defmodule CenWeb.Schemas.CreateUserRequest do
  @moduledoc false
  alias Cen.Accounts.User
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "CreateUserRequest",
    type: :object,
    required: ~w[user]a,
    additionalProperties: false,
    properties: %{
      user: %Schema{
        type: :object,
        required: ~w[password email fullname role phone]a,
        additionalProperties: false,
        properties: %{
          email: %Schema{type: :string},
          password: %Schema{type: :string},
          fullname: %Schema{type: :string},
          role: %Schema{type: :string, enum: User.roles() -- ~w[admin]a},
          birth_date: %Schema{type: :string, format: :date},
          phone: %Schema{type: :string, format: :phone, pattern: ~r/\+\d{9,16}/}
        }
      }
    },
    example: %{
      "user" => %{
        "password" => "123456qwerty",
        "email" => "username@domain.org",
        "fullname" => "Иванов Иван Иванович",
        "role" => "applicant",
        "birth_date" => "2000-01-01",
        "phone" => "+78001234567"
      }
    }
  })
end
