defmodule CenWeb.TokenControllerTest do
  use CenWeb.ConnCase, async: true

  import Cen.AccountsFixtures

  alias CenWeb.Schemas.GenericErrorResponse
  alias CenWeb.Schemas.TokenResponse

  describe "POST /api/token" do
    test "creates token with valid credentials", %{conn: conn} do
      password = "VALID_PASSWORD"
      user = user_fixture(password: password)

      conn = post(conn, ~p"/api/token", %{user: %{email: user.email, password: password}})

      json = json_response(conn, 200)

      assert_schema TokenResponse, json
    end

    test "returns UNAUTHORIZED with invalid credentials", %{conn: conn} do
      user = user_fixture()

      conn = post(conn, ~p"/api/token", %{user: %{email: user.email, password: "INVALID_PASSWORD"}})
      json = json_response(conn, 401)

      assert_schema GenericErrorResponse, json
    end
  end
end
