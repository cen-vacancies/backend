defmodule CenWeb.HealthCheckController do
  use CenWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias CenWeb.Schemas.HealthCheckResponse

  action_fallback CenWeb.FallbackController

  tags ["health_check"]

  operation :check,
    summary: "Check health",
    responses: [
      ok: {"User response", "application/json", HealthCheckResponse}
    ]

  def check(conn, _params) do
    render(conn, :ok)
  end
end
