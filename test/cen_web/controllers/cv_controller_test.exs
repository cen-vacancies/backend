defmodule CenWeb.CVControllerTest do
  use CenWeb.ConnCase

  import Cen.ApplicantsFixtures

  alias Cen.Applicants.CV
  alias CenWeb.Schemas.ChangesetErrorsResponse
  alias CenWeb.Schemas.CVResponse
  alias CenWeb.Schemas.GenericErrorResponse
  alias CenWeb.Schemas.Vacancies.CVsQueryResponse

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

  describe "search cvs" do
    test "list all without query", %{conn: conn} do
      cv_fixture(employment_types: [:main], published: true)
      cv_fixture(employment_types: [:secondary], published: true)

      conn = get(conn, ~p"/api/cvs/search")

      json = json_response(conn, 200)

      assert_schema CVsQueryResponse, json
      assert length(json["data"]) == 2
    end

    test "list only published cvs", %{conn: conn} do
      cv_fixture(employment_types: [:main], published: false)
      cv_fixture(employment_types: [:secondary], published: true)

      conn = get(conn, ~p"/api/cvs/search")

      json = json_response(conn, 200)

      assert_schema CVsQueryResponse, json
      assert length(json["data"]) == 1
    end

    test "list only queried cvs", %{conn: conn} do
      cv_fixture(employment_types: [:main], published: true)
      cv_fixture(employment_types: [:secondary], published: true)

      conn = get(conn, ~p"/api/cvs/search?employment_types[]=main")

      json = json_response(conn, 200)

      assert_schema CVsQueryResponse, json
      assert length(json["data"]) == 1
    end

    test "list only cvs that match the text query", %{conn: conn} do
      cv_fixture(title: "Учитель танцев", published: true)
      cv_fixture(published: true)

      conn = get(conn, ~p"/api/cvs/search?text=танцыё")

      json = json_response(conn, 200)

      assert_schema CVsQueryResponse, json
      assert length(json["data"]) == 1
    end

    test "pagination works", %{conn: conn} do
      Enum.each(1..55, fn _num -> cv_fixture(published: true) end)

      conn = get(conn, ~p"/api/cvs/search")

      json = json_response(conn, 200)

      assert_schema CVsQueryResponse, json

      assert json["page"] == %{
               "page_number" => 1,
               "page_size" => 10,
               "total_entries" => 55,
               "total_pages" => 6
             }
    end

    test "set page size", %{conn: conn} do
      conn = get(conn, ~p"/api/cvs/search?page_size=15")

      json = json_response(conn, 200)

      assert_schema CVsQueryResponse, json
      assert json["page"]["page_size"] == 15
    end

    test "set page number", %{conn: conn} do
      first_vacancy = cv_fixture(published: true)
      secondary_vacancy = cv_fixture(published: true)

      first_conn = get(conn, ~p"/api/cvs/search?page=1&page_size=1")

      first_json = json_response(first_conn, 200)

      assert_schema CVsQueryResponse, first_json
      assert first_json |> Map.fetch!("data") |> Enum.at(0) |> Map.fetch!("id") == first_vacancy.id

      second_conn = get(conn, ~p"/api/cvs/search?page=2&page_size=1")

      second_json = json_response(second_conn, 200)

      assert_schema CVsQueryResponse, second_json
      assert second_json |> Map.fetch!("data") |> Enum.at(0) |> Map.fetch!("id") == secondary_vacancy.id
    end

    test "shows with given education and higher", %{conn: conn} do
      cv_fixture(educations: [%{level: :none}], published: true)
      cv_fixture(educations: [%{level: :secondary}], published: true)
      cv_fixture(educations: [%{level: :higher}], published: true)

      conn = get(conn, ~p"/api/cvs/search?education=secondary")
      json = json_response(conn, 200)

      assert_schema CVsQueryResponse, json
      assert json["page"]["total_entries"] == 2
    end
  end

  defp create_cv(%{user: applicant}) do
    cv = cv_fixture(applicant: applicant)
    %{cv: cv}
  end
end
