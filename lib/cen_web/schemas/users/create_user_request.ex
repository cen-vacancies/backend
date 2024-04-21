defmodule CenWeb.Schemas.CreateUserRequest do
  @moduledoc false

  use CenWeb.StrictAPISchema

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      user: %{
        type: :object,
        optional: [:birth_date],
        properties: %{
          email: %{type: :string},
          password: %{type: :string},
          fullname: %{type: :string},
          role: %{type: :string, enum: Cen.Enums.user_roles() -- ~w[admin]a},
          birth_date: %{type: :string, format: :date},
          phone: %{type: :string, format: :phone, pattern: ~r/\+\d{9,16}/}
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
