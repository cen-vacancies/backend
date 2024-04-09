defmodule CenWeb.Schemas.UserResponse do
  @moduledoc false
  alias CenWeb.Schemas.User

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "User response",
    type: :object,
    required: ~w[data]a,
    properties: %{
      data: User.schema()
    },
    example: %{
      "data" => User.schema().example()
    }
  })
end
