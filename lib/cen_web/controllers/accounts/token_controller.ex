defmodule CenWeb.TokenController do
  use CenWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias CenWeb.Schemas.TokenResponse
  alias CenWeb.Schemas.UserCredentials

  action_fallback CenWeb.FallbackController

  tags :authorization

  operation :create,
    summary: "Get access token",
    request_body: {"credentials", "application/json", UserCredentials},
    responses: [
      ok: {"User's token", "application/json", TokenResponse}
    ]

  operation :delete,
    summary: "Delete user",
    parameters: [
      # TODO: add token example
      token: [in: :path, description: "Token", type: :string, example: "vizKaJNoEnvK8ZR6tXTgPMgNC5Vk6LDx0eLaxkpFZJM"]
    ],
    responses: [
      no_content: "Empty response"
    ]
end
