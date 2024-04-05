defmodule CenWeb.UserControllerTest do
  use CenWeb.ConnCase, async: true

  import Cen.AccountsFixtures

  alias CenWeb.Schemas.ChangesetErrorsResponse
  alias CenWeb.Schemas.NotFoundErrorResponse
  alias CenWeb.Schemas.UserResponse

  describe "POST /api/users" do
    test "creates new applicant", %{conn: conn} do
      applicant_attrs = %{
        password: "123456qwerty",
        email: "username@domain.org",
        fullname: "Иванов Иван Иванович",
        role: "applicant",
        birth_date: "2000-01-01"
      }

      conn = post(conn, ~p"/api/users", %{user: applicant_attrs})
      json = json_response(conn, 201)

      assert_schema UserResponse, json
      assert %{"data" => %{}} = json
    end

    test "creates new employer", %{conn: conn} do
      employer_attrs = %{
        password: "123456qwerty",
        email: "username@domain.org",
        fullname: "Иванов Иван Иванович",
        role: "employer",
        birth_date: "2000-01-01"
      }

      conn = post(conn, ~p"/api/users", %{user: employer_attrs})
      json = json_response(conn, 201)

      assert_schema UserResponse, json
      assert %{"data" => %{}} = json
    end

    test "can't create new admin", %{conn: conn} do
      admin_attrs = %{
        password: "123456qwerty",
        email: "username@domain.org",
        fullname: "Иванов Иван Иванович",
        role: "admin",
        birth_date: "2000-01-01"
      }

      conn = post(conn, ~p"/api/users", %{user: admin_attrs})
      json = json_response(conn, 422)

      assert_schema ChangesetErrorsResponse, json
      assert %{"errors" => %{}} = json
    end

    test "returns error when attrs are invalid", %{conn: conn} do
      invalid_attrs = %{
        "password" => "short",
        "email" => "with spaces",
        "role" => "admin"
      }

      conn = post(conn, ~p"/api/users", %{user: invalid_attrs})

      json = json_response(conn, 422)

      assert_schema ChangesetErrorsResponse, json

      assert %{
               "errors" => %{
                 "email" => _email_errors,
                 "fullname" => _fullname_errors,
                 "password" => _password_errors,
                 "role" => _role_errors
               }
             } = json
    end
  end

  describe "GET /api/users/:user_id" do
    setup do
      %{user: user_fixture()}
    end

    test "shows user", %{conn: conn, user: user} do
      conn = get(conn, ~p"/api/users/#{user}")

      json = json_response(conn, 200)

      assert_schema UserResponse, json
      assert %{"data" => %{}} = json
    end

    test "shows 404 when no user with provided id", %{conn: conn} do
      conn = get(conn, ~p"/api/users/-1")

      json = json_response(conn, 404)

      assert_schema NotFoundErrorResponse, json
      assert %{"errors" => %{}} = json
    end
  end

  describe "PATCH /api/users/:user_id/info" do
    setup do
      %{user: user_fixture()}
    end

    test "updates user info", %{conn: conn, user: user} do
      valid_attrs = %{
        birth_date: Date.new!(1991, 12, 8),
        fullname: "Васильев Василий Васильевич"
      }

      conn = patch(conn, ~p"/api/users/#{user}/info", %{user: valid_attrs})

      json = json_response(conn, 200)

      assert_schema UserResponse, json
      assert %{"data" => %{}} = json
    end

    test "shows 404 when no user with provided id", %{conn: conn} do
      valid_attrs = %{
        birth_date: Date.new!(1991, 12, 8),
        fullname: "Васильев Василий Васильевич"
      }

      conn = patch(conn, ~p"/api/users/-1/info", %{user: valid_attrs})

      json = json_response(conn, 404)

      assert_schema NotFoundErrorResponse, json
      assert %{"errors" => %{}} = json
    end

    test "returns error when attrs are invalid", %{conn: conn, user: user} do
      invalid_attrs = %{
        fullname: ""
      }

      conn = patch(conn, ~p"/api/users/#{user}/info", %{user: invalid_attrs})

      json = json_response(conn, 422)

      assert_schema ChangesetErrorsResponse, json
      assert %{"errors" => %{}} = json
    end
  end

  describe "DELETE /api/users/:user_id" do
    setup do
      %{user: user_fixture()}
    end

    test "deletes user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")

      assert "" = response(conn, 204)
    end

    test "returns success when user is not exists", %{conn: conn} do
      conn = delete(conn, ~p"/api/users/-1")

      assert "" = response(conn, 204)
    end
  end
end
