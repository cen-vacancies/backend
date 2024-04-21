defmodule CenWeb.Schemas.HealthCheckResponse do
  @moduledoc false

  use CenWeb.StrictAPISchema

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      status: %{type: :string, description: "API status", pattern: "ok"}
    },
    example: %{
      "status" => "ok"
    }
  })
end
