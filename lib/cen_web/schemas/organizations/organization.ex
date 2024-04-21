defmodule CenWeb.Schemas.Organization do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.User

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      id: %{type: :integer},
      name: %{type: :string},
      logo: %{type: :string},
      description: %{type: :string},
      address: %{type: :string},
      contacts: %{type: :string},
      employer: User.schema()
    },
    example: %{
      "id" => "756",
      "name" => "УрФУ имени первого Президента России Б.Н. Ельцина",
      "logo" => "/uploads/urfu.png",
      "description" => "applicant",
      "address" => "620002, Свердловская область, г. Екатеринбург, ул. Мира, д. 19",
      "contacts" => "+78005553535",
      "employer" => User.schema().example
    }
  })
end
