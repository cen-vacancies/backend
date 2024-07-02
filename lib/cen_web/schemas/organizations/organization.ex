defmodule CenWeb.Schemas.Organization do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.Phone
  alias CenWeb.Schemas.User

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      id: %{type: :integer},
      name: %{type: :string, maxLength: 160},
      logo: %{type: :string},
      description: %{type: :string, maxLength: 2000},
      address: %{type: :string, maxLength: 160},
      phone: Phone.schema(),
      email: %{type: :string, maxLength: 160},
      website: %{type: :string, maxLength: 160},
      social_link: %{type: :string, maxLength: 160},
      employer: User.schema()
    },
    example: %{
      "id" => "756",
      "name" => "УрФУ имени первого Президента России Б.Н. Ельцина",
      "logo" => "/uploads/urfu.png",
      "description" => "applicant",
      "address" => "620002, Свердловская область, г. Екатеринбург, ул. Мира, д. 19",
      "phone" => "+7001005044",
      "email" => "contact@urfu.ru",
      "website" => "https://urfu.me",
      "social_link" => "https://vk.com/ural.federal.university",
      "employer" => User.schema().example
    }
  })
end
