defmodule CenWeb.Schemas.HealthCheckResponse do
  @moduledoc false
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Health check response",
    type: :object,
    properties: %{
      status: %Schema{type: :string, description: "API status", pattern: "ok"}
    },
    required: [:status],
    example: %{
      "status" => "ok"
    }
  })
end
