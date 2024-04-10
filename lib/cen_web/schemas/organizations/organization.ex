defmodule CenWeb.Schemas.Organization do
  @moduledoc false
  alias CenWeb.Schemas.User
  alias OpenApiSpex.Schema

  require OpenApiSpex

  user_emplyer_schema =
    User.schema()
    |> update_in([Access.key!(:properties), :role], fn _role_schema ->
      %Schema{type: :string, format: "employer"}
    end)
    |> update_in([Access.key!(:example), "role"], fn _role -> "employer" end)
    |> Map.put(:nullable, true)

  OpenApiSpex.schema(%{
    title: "Organization",
    type: :object,
    required: ~w[id name logo description address contacts employer]a,
    properties: %{
      id: %Schema{type: :integer},
      name: %Schema{type: :string},
      logo: %Schema{type: :string},
      description: %Schema{type: :string},
      address: %Schema{type: :string},
      contacts: %Schema{type: :string},
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
