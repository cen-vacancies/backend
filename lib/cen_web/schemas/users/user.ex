defmodule CenWeb.Schemas.User do
  @moduledoc false

  require CenWeb.StrictAPISchema

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      id: %{type: :integer},
      email: %{type: :string},
      fullname: %{type: :string},
      role: %{type: :string, enum: Cen.Enums.user_roles()},
      birth_date: %{type: :string, format: :date, nullable: true},
      phone: %{type: :string, format: :phone, pattern: ~r/\+\d{9,16}/}
    },
    example: %{
      "id" => "756",
      "email" => "username@domain.org",
      "fullname" => "Иванов Иван Иванович",
      "role" => "applicant",
      "birth_date" => "2000-01-01",
      "phone" => "+78001234567"
    }
  })
end
