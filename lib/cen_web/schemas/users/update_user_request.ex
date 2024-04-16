defmodule CenWeb.Schemas.UpdateUserInfoRequest do
  @moduledoc false
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "UpdateUserRequest",
    type: :object,
    required: ~w[user]a,
    properties: %{
      user: %Schema{
        type: :object,
        properties: %{
          fullname: %Schema{type: :string},
          birth_date: %Schema{type: :string, format: :date}
        }
      }
    },
    example: %{
      "user" => %{
        "fullname" => "Иванов Иван Иванович",
        "birth_date" => "2000-01-01"
      }
    }
  })
end
