defmodule CenWeb.Schemas.UpdateUserInfoRequest do
  @moduledoc false
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "UpdateUserRequest",
    type: :object,
    required: ~w[user]a,
    additionalProperties: false,
    properties: %{
      user: %Schema{
        type: :object,
        additionalProperties: false,
        properties: %{
          fullname: %Schema{type: :string},
          birth_date: %Schema{type: :string, format: :date},
          phone: %Schema{type: :string, format: :phone, pattern: ~r/\+\d{9,16}/}
        }
      }
    },
    example: %{
      "user" => %{
        "fullname" => "Иванов Иван Иванович",
        "birth_date" => "2000-01-01",
        "phone" => "+78001234567"
      }
    }
  })
end
