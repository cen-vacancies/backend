defmodule CenWeb.Schemas.CreateUserRequest do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.User

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      user: %{
        type: :object,
        properties:
          using_properties(User.schema(),
            only: ~w[email password fullname birth_date phone]a,
            add: %{
              role: %{type: :string, enum: Cen.Enums.user_roles() -- ~w[admin]a},
              password: %{
                type: :string,
                maxLength: 72,
                minLength: 12
              }
            }
          )
      }
    },
    example: %{
      "user" =>
        using_example(User.schema(),
          only: ~w(email password fullname birth_date phone),
          add: %{"role" => "applicant", "password" => "123456qwerty"}
        )
    }
  })
end
