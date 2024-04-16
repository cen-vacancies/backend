defmodule CenWeb.UserControllerTest do
  use CenWeb.ConnCase, async: true

  alias CenWeb.Schemas.ChangesetErrorsResponse
  alias CenWeb.Schemas.GenericErrorResponse
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
    end
  end

  describe "GET /api/users/me" do
    setup :register_and_log_in_user

    test "shows user", %{conn: conn} do
      conn = get(conn, ~p"/api/users/me")

      json = json_response(conn, 200)

      assert_schema UserResponse, json
    end

    test "returns unauthorized when not logged in", %{conn: conn} do
      conn =
        conn
        |> delete_req_header("authorization")
        |> get(~p"/api/users/me")

      json = json_response(conn, 401)
      assert_schema GenericErrorResponse, json
    end
  end

  describe "PATCH /api/users/me/info" do
    setup :register_and_log_in_user

    test "updates user info", %{conn: conn} do
      valid_attrs = %{
        birth_date: Date.new!(1991, 12, 8),
        fullname: "Васильев Василий Васильевич"
      }

      conn = patch(conn, ~p"/api/users/me/info", %{user: valid_attrs})

      json = json_response(conn, 200)

      assert_schema UserResponse, json
    end

    test "returns error when attrs are invalid", %{conn: conn} do
      invalid_attrs = %{
        fullname: ""
      }

      conn = patch(conn, ~p"/api/users/me/info", %{user: invalid_attrs})

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
        |> patch(~p"/api/users/me/info", %{user: valid_attrs})

      json = json_response(conn, 401)
      assert_schema GenericErrorResponse, json
    end
  end

  describe "DELETE /api/users/me" do
    setup :register_and_log_in_user

    test "deletes user", %{conn: conn} do
      conn = delete(conn, ~p"/api/users/me")

      assert "" = response(conn, 204)
    end

    test "returns unauthorized when not logged in", %{conn: conn} do
      conn =
        conn
        |> delete_req_header("authorization")
        |> delete(~p"/api/users/me")

      json = json_response(conn, 401)
      assert_schema GenericErrorResponse, json
    end
  end
end
