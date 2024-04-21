defmodule CenWeb.CVControllerTest do
  use CenWeb.ConnCase

  import Cen.ApplicantsFixtures

  alias Cen.Applicants.CV
  alias CenWeb.Schemas.ChangesetErrorsResponse
  alias CenWeb.Schemas.CVResponse
  alias CenWeb.Schemas.GenericErrorResponse

  @create_attrs %{
    title: "some title",
    summary: "some summary",
    published: true,
    reviewed: true,
    employment_types: [:main, :internship],
    work_schedules: [:remote_working],
    field_of_art: :visual,
    years_of_work_experience: 42,
    educations: []
  }
  @update_attrs %{
    title: "some updated title",
    summary: "some updated summary",
    published: false,
    reviewed: false,
    employment_types: [:practice],
    work_schedules: [:hybrid_working],
    field_of_art: :music,
    years_of_work_experience: 43,
    educations: []
  }
  @invalid_attrs %{
    title: nil,
    summary: nil,
    published: nil,
    reviewed: nil,
    employment_types: nil,
    work_schedules: nil,
    field_of_art: nil,
    years_of_work_experience: nil,
    education: nil
  }

  setup %{conn: conn} do
    applicant = Cen.AccountsFixtures.user_fixture(role: :applicant)
    employer = Cen.AccountsFixtures.user_fixture(role: :employer)

    %{
      conn: log_in_user(conn, applicant),
      user: applicant,
      conn_employer: log_in_user(conn, employer)
    }
  end

  describe "create cv" do
    test "renders cv when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/cvs", cv: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn_get = get(conn, ~p"/api/cvs/#{id}")

      json = json_response(conn_get, 200)

      assert_schema CVResponse, json

      assert %{
               "id" => ^id,
               "employment_types" => ["main", "internship"],
               "field_of_art" => "visual",
               "published" => true,
               "reviewed" => true,
               "summary" => "some summary",
               "work_schedules" => ["remote_working"],
               "years_of_work_experience" => 42
             } = json["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/cvs", cv: @invalid_attrs)
      json = json_response(conn, 422)

      assert json["errors"] != %{}
      assert_schema ChangesetErrorsResponse, json
    end

    test "renders forbidden error when user is employer", %{conn_employer: conn} do
      conn = post(conn, ~p"/api/cvs", cv: @invalid_attrs)
      json = json_response(conn, 403)

      assert_schema GenericErrorResponse, json
    end
  end

  describe "update cv" do
    setup [:create_cv]

    test "renders cv when data is valid", %{conn: conn, cv: %CV{id: id} = cv} do
      conn = patch(conn, ~p"/api/cvs/#{cv}", cv: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn_get = get(conn, ~p"/api/cvs/#{id}")

      json = json_response(conn_get, 200)

      assert_schema CVResponse, json
    end

    test "renders errors when data is invalid", %{conn: conn, cv: cv} do
      conn = patch(conn, ~p"/api/cvs/#{cv}", cv: @invalid_attrs)
      json = json_response(conn, 422)

      assert json["errors"] != %{}
      assert_schema ChangesetErrorsResponse, json
    end

    test "renders forbidden error when user is not owner", %{conn_employer: conn, cv: cv} do
      conn = patch(conn, ~p"/api/cvs/#{cv}", cv: @update_attrs)
      json = json_response(conn, 403)

      assert_schema GenericErrorResponse, json
    end
  end

  describe "delete cv" do
    setup [:create_cv]

    test "deletes chosen cv", %{conn: conn, cv: cv} do
      conn = delete(conn, ~p"/api/cvs/#{cv}")
      assert response(conn, 204)

      conn
      |> get(~p"/api/cvs/#{cv}")
      |> response(404)
    end
  end

  defp create_cv(%{user: applicant}) do
    cv = cv_fixture(applicant: applicant)
    %{cv: cv}
  end
end
