defmodule CenWeb.Schemas.UpdateUserInfoRequest do
  @moduledoc false

  require CenWeb.StrictAPISchema

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      user: %{
        type: :object,
        optional: :all,
        properties: %{
          fullname: %{type: :string},
          birth_date: %{type: :string, format: :date},
          phone: %{type: :string, format: :phone, pattern: ~r/\+\d{9,16}/}
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
