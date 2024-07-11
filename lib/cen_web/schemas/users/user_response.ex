defmodule CenWeb.Schemas.UserResponse do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.User

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      data: User.schema()
    },
    example: %{
      "data" => User.schema().example
    }
  })
end
