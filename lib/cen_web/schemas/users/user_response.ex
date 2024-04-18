defmodule CenWeb.Schemas.UserResponse do
  @moduledoc false
  alias CenWeb.Schemas.User

  require CenWeb.StrictAPISchema

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      data: User.schema()
    },
    example: %{
      "data" => User.schema().example()
    }
  })
end
