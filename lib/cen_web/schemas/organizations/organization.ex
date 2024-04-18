defmodule CenWeb.Schemas.Organization do
  @moduledoc false
  alias CenWeb.Schemas.User

  require CenWeb.StrictAPISchema

  user_emplyer_schema =
    User.schema()
    |> update_in([Access.key!(:properties), :role], fn _role_schema ->
      %OpenApiSpex.Schema{type: :string, format: "employer"}
    end)
    |> update_in([Access.key!(:example), "role"], fn _role -> "employer" end)

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      id: %{type: :integer},
      name: %{type: :string},
      logo: %{type: :string},
      description: %{type: :string},
      address: %{type: :string},
      contacts: %{type: :string},
      employer: user_emplyer_schema
    },
    example: %{
      "id" => "756",
      "name" => "УрФУ имени первого Президента России Б.Н. Ельцина",
      "logo" => "/uploads/urfu.png",
      "description" => "applicant",
      "address" => "620002, Свердловская область, г. Екатеринбург, ул. Мира, д. 19",
      "contacts" => "+78005553535",
      "employer" => user_emplyer_schema.example
    }
  })
end
