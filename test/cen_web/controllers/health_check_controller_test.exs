defmodule CenWeb.HealthCheckControllerTest do
  use CenWeb.ConnCase, async: true

  alias CenWeb.Schemas.HealthCheckResponse

  test "GET /api/health/check", %{conn: conn} do
    conn = get(conn, "/api/health/check")

    assert json = json_response(conn, 200)
    assert_schema HealthCheckResponse, json
  end
end
