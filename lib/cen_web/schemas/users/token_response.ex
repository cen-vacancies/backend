defmodule CenWeb.Schemas.TokenResponse do
  @moduledoc false
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "User's token",
    type: :object,
    required: ~w[data]a,
    properties: %{
      data: %Schema{
        type: :object,
        required: ~w[token]a,
        properties: %{
          token: %Schema{type: :string}
        }
      }
    },
    example: %{
      "data" => %{
        "token" => "vizKaJNoEnvK8ZR6tXTgPMgNC5Vk6LDx0eLaxkpFZJM"
      }
    }
  })
end
