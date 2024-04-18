defmodule CenWeb.Schemas.Organizations.UpdateOrganizationRequest do
  @moduledoc false

  require CenWeb.StrictAPISchema

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      organization: %{
        type: :object,
        optional: :all,
        properties: %{
          name: %{type: :string, maximum: 255},
          logo: %{type: :string},
          description: %{type: :string, maximum: 2000},
          address: %{type: :string, maximum: 255},
          contacts: %{type: :string, maximum: 255}
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
