defmodule CenWeb.Schemas.User do
  @moduledoc false
  alias Cen.Accounts.User
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "User",
    type: :object,
    required: ~w[id email fullname role birth_date]a,
    properties: %{
      id: %Schema{type: :integer},
      email: %Schema{type: :string},
      fullname: %Schema{type: :string},
      role: %Schema{type: :string, enum: User.roles()},
      birth_date: %Schema{type: :string, format: :date, nullable: true}
    },
    example: %{
      "id" => "756",
      "email" => "username@domain.org",
      "fullname" => "Иванов Иван Иванович",
      "role" => "applicant",
      "birth_date" => "2000-01-01"
    }
  })
end
