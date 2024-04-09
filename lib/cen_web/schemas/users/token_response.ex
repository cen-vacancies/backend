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
          token: %Schema{type: :string, format: "JWT"}
        }
      }
    },
    example: %{
      "data" => %{
        "token" =>
          "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJjZW4tdmFjYW5jaWVzIiwiZXhwIjoxNzE1MTA0ODc3LCJpYXQiOjE3MTI2ODU2NzcsImlzcyI6ImNlbi12YWNhbmNpZXMiLCJqdGkiOiJmMzk5ZmQzMC0yYjJhLTQ4ZjMtODE1ZC0zNWU4MzhhYjNiODciLCJuYmYiOjE3MTI2ODU2NzYsInN1YiI6IjEiLCJ0eXAiOiJhY2Nlc3MifQ.18NmnxCYERqKFu5O0VjY85qZsDkCHL0vy0uYJ1suFJPSjiZrNS2RGQobmE8mO9P5-MkyL-_-Kp4EwWvBnCUwyA"
      }
    }
  })
end
