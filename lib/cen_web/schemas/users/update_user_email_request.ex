defmodule CenWeb.Schemas.UpdateUserEmailRequest do
  @moduledoc false

  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.User

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      user: %{
        type: :object,
        properties: using_properties(User.schema(), only: ~w[email]a, add: %{current_password: %{type: :string}})
      }
    },
    example: %{
      "user" => using_example(User.schema(), only: ~w(email), add: %{"current_password" => "123456qwerty"})
    }
  })
end
