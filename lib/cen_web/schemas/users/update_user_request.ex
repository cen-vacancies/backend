defmodule CenWeb.Schemas.UpdateUserRequest do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.User

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      user: %{
        type: :object,
        optional: :all,
        properties: using_properties(User.schema(), only: ~w[fullname birth_date phone email]a)
      }
    },
    example: %{
      "user" => using_example(User.schema(), only: ~w(fullname birth_date phone email))
    }
  })
end
