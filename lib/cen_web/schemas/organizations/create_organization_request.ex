defmodule CenWeb.Schemas.CreateOrganizationRequest do
  @moduledoc false
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Organization params",
    type: :object,
    required: ~w[organization]a,
    properties: %{
      organization: %Schema{
        type: :object,
        required: ~w[name description address contacts]a,
        properties: %{
          name: %Schema{type: :string, maximum: 255},
          logo: %Schema{type: :string},
          description: %Schema{type: :string, maximum: 2000},
          address: %Schema{type: :string, maximum: 255},
          contacts: %Schema{type: :string, maximum: 255}
        }
      }
    },
    example: %{
      "organization" => %{
        "name" => "УрФУ имени первого Президента России Б.Н. Ельцина",
        "logo" => "/uploads/urfu.png",
        "description" => "applicant",
        "address" => "620002, Свердловская область, г. Екатеринбург, ул. Мира, д. 19",
        "contacts" => "+78005553535"
      }
    }
  })
end
