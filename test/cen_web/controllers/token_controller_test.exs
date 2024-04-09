defmodule CenWeb.TokenControllerTest do
  use CenWeb.ConnCase

  import Cen.AccountsFixtures

  alias CenWeb.Schemas.TokenResponse

  describe "POST /api/tokens" do
    test "creates token with valid credentials", %{conn: conn} do
      password = "VALID_PASSWORD"
      user = user_fixture(password: password)

      conn = post(conn, ~p"/api/tokens", %{user: %{email: user.email, password: password}})

      json = json_response(conn, 200)

      assert_schema TokenResponse, json
      assert %{"data" => %{"token" => _token}} = json
    end

    test "returns UNAUTHORIZED with invalid credentials", %{conn: conn} do
      user = user_fixture()

      conn = post(conn, ~p"/api/tokens", %{user: %{email: user.email, password: "INVALID_PASSWORD"}})

      assert "" = response(conn, 401)
    end
  end
end
