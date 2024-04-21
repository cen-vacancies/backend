defmodule CenWeb.Schemas.UserCredentials do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.User

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      user: %{
        type: :object,
        properties: using_properties(User.schema(), only: [:email], add: %{password: %{type: :string}})
      }
    },
    example: %{
      "user" => using_example(User.schema(), only: ["email"], add: %{"password" => "123456qwerty"})
    }
  })
end
