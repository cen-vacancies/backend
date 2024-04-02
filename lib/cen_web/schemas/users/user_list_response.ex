defmodule CenWeb.Schemas.UsersListResponse do
  @moduledoc false
  alias CenWeb.Schemas.User
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Users list response",
    type: :object,
    required: ~w[data]a,
    properties: %{
      data: %Schema{type: :array, items: User.schema()}
    },
    example: %{
      "data" => [User.schema().example]
    }
  })
end
