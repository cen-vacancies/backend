defmodule CenWeb.CVControllerTest do
  use CenWeb.ConnCase, async: true

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
    educations: [
      %{
        level: :bachelor,
        educational_institution: "some insistute",
        department: nil,
        specialization: "some specialization",
        year_of_graduation: 2024
      }
    ],
    jobs: [
      %{
        organization_name: "some org",
        job_title: "some job",
        description: "some description",
        start_date: ~D[2024-01-01],
        end_date: ~D[2024-01-02]
      }
    ]
  }
  @update_attrs %{
    title: "some updated title",
    summary: "some updated summary",
    published: false,
    reviewed: false,
    employment_types: [:practice],
    work_schedules: [:hybrid_working],
    field_of_art: :music,
    educations: [
      %{
        level: :bachelor,
        educational_institution: "updated institute",
        department: nil,
        specialization: "updated specialization",
        year_of_graduation: 2024
      }
    ]
  }
  @invalid_attrs %{
    title: nil,
    summary: nil,
    published: nil,
    reviewed: nil,
    employment_types: nil,
    work_schedules: nil,
    field_of_art: nil,
    educations: []
  }

  setup %{conn: conn} do
    applicant = Cen.AccountsFixtures.user_fixture(role: :applicant)
    employer = Cen.AccountsFixtures.user_fixture(role: :employer)
    admin = Cen.AccountsFixtures.user_fixture(role: :admin)

    %{
      conn: log_in_user(conn, applicant),
      user: applicant,
      conn_employer: log_in_user(conn, employer),
      conn_admin: log_in_user(conn, admin)
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
               "reviewed" => false,
               "summary" => "some summary",
               "work_schedules" => ["remote_working"]
             } = json["data"]
    end

    test "error on create cv without educations", %{conn: conn} do
      attrs = Map.put(@create_attrs, :educations, [])
      conn = post(conn, ~p"/api/cvs", cv: attrs)

      json = json_response(conn, 422)

      assert json["errors"] != %{}
      assert_schema ChangesetErrorsResponse, json
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
      assert json["data"]["reviewed"] == true

      assert_schema CVResponse, json
    end

    test "updates cv when user is not author but admin", %{conn_admin: conn, cv: %CV{id: id} = cv} do
      conn = patch(conn, ~p"/api/cvs/#{cv}", cv: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn_get = get(conn, ~p"/api/cvs/#{cv}")

      json = json_response(conn_get, 200)
      assert json["data"]["reviewed"] == false

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

    test "deletes chosen cv when not owner but admin", %{conn_admin: conn, cv: cv} do
      conn = delete(conn, ~p"/api/cvs/#{cv}")
      assert response(conn, 204)

      conn
      |> get(~p"/api/cvs/#{cv}")
      |> response(404)
    end

    test "returns error when not owner", %{conn_employer: conn, cv: cv} do
      conn = delete(conn, ~p"/api/cvs/#{cv}")
      assert response(conn, 403)

      conn
      |> get(~p"/api/cvs/#{cv}")
      |> response(200)
    end
  end

  describe "search cvs" do
    test "list all without query", %{conn: conn} do
      cv_fixture(employment_types: [:main], published: true, reviewed: true)
      cv_fixture(employment_types: [:secondary], published: true, reviewed: true)

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
               "page_size" => 50,
               "total_entries" => 55,
               "total_pages" => 2
             }
    end

    test "set page size", %{conn: conn} do
      conn = get(conn, ~p"/api/cvs/search?page_size=15")

      json = json_response(conn, 200)

      assert_schema CVsQueryResponse, json
      assert json["page"]["page_size"] == 15
    end

    test "set page number", %{conn: conn} do
      first_cv = cv_fixture(published: true)
      secondary_cv = cv_fixture(published: true)

      first_conn = get(conn, ~p"/api/cvs/search?page=1&page_size=1")

      first_json = json_response(first_conn, 200)

      assert_schema CVsQueryResponse, first_json
      assert first_json |> Map.fetch!("data") |> Enum.at(0) |> Map.fetch!("id") == first_cv.id

      second_conn = get(conn, ~p"/api/cvs/search?page=2&page_size=1")

      second_json = json_response(second_conn, 200)

      assert_schema CVsQueryResponse, second_json
      assert second_json |> Map.fetch!("data") |> Enum.at(0) |> Map.fetch!("id") == secondary_cv.id
    end

    test "shows with given education and bachelor", %{conn: conn} do
      education = %{level: nil, educational_institution: "institute", specialization: "spec", year_of_graduation: 2024}

      cv_fixture(educations: [%{education | level: :secondary}], published: true)
      cv_fixture(educations: [%{education | level: :secondary_vocational}], published: true)
      cv_fixture(educations: [%{education | level: :bachelor}], published: true)

      conn = get(conn, ~p"/api/cvs/search?education=secondary_vocational")
      json = json_response(conn, 200)

      assert_schema CVsQueryResponse, json
      assert json["page"]["total_entries"] == 2
    end
  end

  describe "list user's CVs" do
    setup %{conn: conn} do
      applicant_1 = Cen.AccountsFixtures.user_fixture(role: :applicant)
      create_cv(%{user: applicant_1})

      applicant_2 = Cen.AccountsFixtures.user_fixture(role: :applicant)
      create_cv(%{user: applicant_2})

      %{
        conn: log_in_user(conn, applicant_1)
      }
    end

    test "returns only current_user CVs", %{conn: conn} do
      conn = get(conn, "/api/user/cvs")

      json = json_response(conn, 200)

      assert_schema CVsQueryResponse, json
      assert length(json["data"]) == 1
    end
  end

  defp create_cv(%{user: applicant}) do
    cv = cv_fixture(applicant: applicant)
    %{cv: cv}
  end
end
