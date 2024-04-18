defmodule CenWeb.Schemas.HealthCheckResponse do
  @moduledoc false

  require CenWeb.StrictAPISchema

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
