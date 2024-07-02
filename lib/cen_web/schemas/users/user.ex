defmodule CenWeb.Schemas.User do
  @moduledoc false

  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.Phone

  @email_description """
  User email

  - Must be no longer than 160 characters
  - Must have the @ sign and no spaces
  - Must be unique

  Same email can't be used to create accounts with different roles.
  """

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      id: %{type: :integer},
      email: %{type: :string, description: @email_description, maxLength: 60},
      fullname: %{type: :string, maxLength: 160},
      role: %{type: :string, enum: Cen.Enums.user_roles()},
      birth_date: %{type: :string, format: :date},
      phone: Phone.schema()
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
