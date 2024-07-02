defmodule CenWeb.Schemas.User do
  @moduledoc false

  use CenWeb.StrictAPISchema

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      id: %{type: :integer},
      email: %{type: :string},
      fullname: %{type: :string},
      role: %{type: :string, enum: Cen.Enums.user_roles()},
      birth_date: %{type: :string, format: :date},
      phone: %{type: :string}
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
