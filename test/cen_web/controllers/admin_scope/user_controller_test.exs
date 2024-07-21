defmodule CenWeb.AdminScope.UserControllerTest do
  use CenWeb.ConnCase, async: true

  import Cen.AccountsFixtures

  alias CenWeb.Schemas.GenericErrorResponse
  alias CenWeb.Schemas.UsersListResponse

  setup %{conn: conn} do
    admin = user_fixture(role: :admin)
    not_admin = user_fixture()

    %{
      conn: log_in_user(conn, admin),
      conn_not_admin: log_in_user(conn, not_admin)
    }
  end

  describe "list users" do
    test "renders list of users", %{conn: conn} do
      conn = get(conn, ~p"/api/admin/users")

      json = json_response(conn, 200)

      assert_schema UsersListResponse, json
    end

    test "can't access without admin role", %{conn_not_admin: conn} do
      conn = get(conn, ~p"/api/admin/users")

      json = json_response(conn, 401)

      assert_schema GenericErrorResponse, json
    end
  end
end
