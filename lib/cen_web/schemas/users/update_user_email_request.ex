defmodule CenWeb.Schemas.UpdateUserEmailRequest do
  @moduledoc false

  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.User

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      user: %{
        type: :object,
        optional: :all,
        properties: using_properties(User.schema(), only: ~w[email]a)
      }
    },
    example: %{
      "user" => using_example(User.schema(), only: ~w(email))
    }
  })
end
