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
      phone: %{type: :string},
      email: %{type: :string},
      website: %{type: :string},
      social_link: %{type: :string},
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
