defmodule CenWeb.Schemas.TokenResponse do
  @moduledoc false

  use CenWeb.StrictAPISchema

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      data: %{
        type: :object,
        properties: %{
          token: %{type: :string, format: "JWT"}
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
