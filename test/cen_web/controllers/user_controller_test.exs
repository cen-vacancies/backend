defmodule CenWeb.UserControllerTest do
  use CenWeb.ConnCase, async: true

  alias Cen.AccountsFixtures
  alias CenWeb.Schemas.ChangesetErrorsResponse
  alias CenWeb.Schemas.GenericErrorResponse
  alias CenWeb.Schemas.UserResponse

  describe "POST /api/user" do
    test "creates new applicant", %{conn: conn} do
      applicant_attrs = %{
        password: "123456qwerty",
        email: "username@domain.org",
        fullname: "Иванов Иван Иванович",
        role: "applicant",
        birth_date: "2000-01-01",
        phone: "+78001234567"
      }

      conn = post(conn, ~p"/api/user", %{user: applicant_attrs})
      json = json_response(conn, 201)

      assert_schema UserResponse, json
    end

    test "creates new employer", %{conn: conn} do
      employer_attrs = %{
        password: "123456qwerty",
        email: "username@domain.org",
        fullname: "Иванов Иван Иванович",
        role: "employer",
        birth_date: "2000-01-01",
        phone: "+78001234567"
      }

      conn = post(conn, ~p"/api/user", %{user: employer_attrs})
      json = json_response(conn, 201)

      assert_schema UserResponse, json
    end

    test "can't create new admin", %{conn: conn} do
      admin_attrs = %{
        password: "123456qwerty",
        email: "username@domain.org",
        fullname: "Иванов Иван Иванович",
        role: "admin",
        birth_date: "2000-01-01"
      }

      conn = post(conn, ~p"/api/user", %{user: admin_attrs})
      json = json_response(conn, 422)

      assert_schema ChangesetErrorsResponse, json
    end

    test "returns error when attrs are invalid", %{conn: conn} do
      invalid_attrs = %{
        "password" => "short",
        "email" => "with spaces",
        "role" => "admin"
      }

      conn = post(conn, ~p"/api/user", %{user: invalid_attrs})

      json = json_response(conn, 422)

      assert_schema ChangesetErrorsResponse, json
    end
  end

  describe "GET /api/user" do
    setup :register_and_log_in_user

    test "shows user", %{conn: conn} do
      conn = get(conn, ~p"/api/user")

      json = json_response(conn, 200)

      assert_schema UserResponse, json
    end

    test "returns unauthorized when not logged in", %{conn: conn} do
      conn =
        conn
        |> delete_req_header("authorization")
        |> get(~p"/api/user")

      json = json_response(conn, 401)
      assert_schema GenericErrorResponse, json
    end
  end

  describe "PATCH /api/user/info" do
    setup :register_and_log_in_user

    test "updates user info", %{conn: conn} do
      valid_attrs = %{
        birth_date: Date.new!(1991, 12, 8),
        fullname: "Васильев Василий Васильевич"
      }

      conn = patch(conn, ~p"/api/user/info", %{user: valid_attrs})

      json = json_response(conn, 200)

      assert_schema UserResponse, json
    end

    test "returns error when attrs are invalid", %{conn: conn} do
      invalid_attrs = %{
        fullname: ""
      }

      conn = patch(conn, ~p"/api/user/info", %{user: invalid_attrs})

      json = json_response(conn, 422)

      assert_schema ChangesetErrorsResponse, json
    end

    test "returns unauthorized when not logged in", %{conn: conn} do
      valid_attrs = %{
        birth_date: Date.new!(1991, 12, 8),
        fullname: "Васильев Василий Васильевич"
      }

      conn =
        conn
        |> delete_req_header("authorization")
        |> patch(~p"/api/user/info", %{user: valid_attrs})

      json = json_response(conn, 401)
      assert_schema GenericErrorResponse, json
    end
  end

  describe "PATCH /api/user/email" do
    setup :register_and_log_in_user

    test "updates user email", %{conn: conn} do
      valid_attrs = %{
        email: "some-test@example.com",
        current_password: AccountsFixtures.valid_user_password()
      }

      conn = patch(conn, ~p"/api/user/email", %{user: valid_attrs})

      json = json_response(conn, 200)

      assert_schema UserResponse, json
    end

    test "returns error when invalid password", %{conn: conn} do
      valid_attrs = %{
        email: "some-test@example.com",
        current_password: "invalid-password"
      }

      conn = patch(conn, ~p"/api/user/email", %{user: valid_attrs})

      json = json_response(conn, 422)

      assert_schema ChangesetErrorsResponse, json
    end

    test "returns error when attrs are invalid", %{conn: conn} do
      invalid_attrs = %{
        email: "invalid-email"
      }

      conn = patch(conn, ~p"/api/user/email", %{user: invalid_attrs})

      json = json_response(conn, 422)

      assert_schema ChangesetErrorsResponse, json
    end

    test "returns unauthorized when not logged in", %{conn: conn} do
      valid_attrs = %{
        email: "some-test@example.com",
        current_password: AccountsFixtures.valid_user_password()
      }

      conn =
        conn
        |> delete_req_header("authorization")
        |> patch(~p"/api/user/email", %{user: valid_attrs})

      json = json_response(conn, 401)
      assert_schema GenericErrorResponse, json
    end
  end

  describe "PATCH /api/user/password" do
    setup :register_and_log_in_user

    test "updates user password", %{conn: conn} do
      valid_attrs = %{
        current_password: AccountsFixtures.valid_user_password(),
        password: "new-password"
      }

      conn = patch(conn, ~p"/api/user/password", %{user: valid_attrs})

      json = json_response(conn, 200)

      assert_schema UserResponse, json
    end

    test "returns error when invalid password", %{conn: conn} do
      valid_attrs = %{
        current_password: "invalid-password",
        password: "new-password"
      }

      conn = patch(conn, ~p"/api/user/password", %{user: valid_attrs})

      json = json_response(conn, 422)

      assert_schema ChangesetErrorsResponse, json
    end

    test "returns error when attrs are invalid", %{conn: conn} do
      invalid_attrs = %{
        password: "new-password"
      }

      conn = patch(conn, ~p"/api/user/password", %{user: invalid_attrs})

      json = json_response(conn, 422)

      assert_schema ChangesetErrorsResponse, json
    end

    test "returns unauthorized when not logged in", %{conn: conn} do
      valid_attrs = %{
        current_password: AccountsFixtures.valid_user_password(),
        password: "new-password"
      }

      conn =
        conn
        |> delete_req_header("authorization")
        |> patch(~p"/api/user/password", %{user: valid_attrs})

      json = json_response(conn, 401)
      assert_schema GenericErrorResponse, json
    end
  end

  describe "DELETE /api/user" do
    setup :register_and_log_in_user

    test "deletes user", %{conn: conn} do
      conn = delete(conn, ~p"/api/user")

      assert "" = response(conn, 204)
    end

    test "returns unauthorized when not logged in", %{conn: conn} do
      conn =
        conn
        |> delete_req_header("authorization")
        |> delete(~p"/api/user")

      json = json_response(conn, 401)
      assert_schema GenericErrorResponse, json
    end
  end
end
