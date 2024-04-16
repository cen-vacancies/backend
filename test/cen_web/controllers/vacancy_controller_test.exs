defmodule CenWeb.VacancyControllerTest do
  use CenWeb.ConnCase

  import Cen.EmployersFixtures

  alias Cen.Employers.Vacancy
  alias CenWeb.Schemas.ChangesetErrorsResponse
  alias CenWeb.Schemas.GenericErrorResponse
  alias CenWeb.Schemas.Vacancies.VacanciesQueryResponse
  alias CenWeb.Schemas.VacancyResponse

  @create_attrs %{
    title: "some title",
    description: "some description",
    employment_type: :main,
    work_schedule: :full_time,
    education: :none,
    field_of_art: :music,
    min_years_of_work_experience: 42,
    proposed_salary: 42
  }
  @update_attrs %{
    description: "some updated description",
    employment_type: :secondary,
    work_schedule: :part_time,
    education: :higher,
    field_of_art: :visual,
    min_years_of_work_experience: 43,
    proposed_salary: 43
  }
  @invalid_attrs %{
    description: nil,
    employment_type: nil,
    work_schedule: nil,
    education: nil,
    field_of_art: nil,
    min_years_of_work_experience: nil,
    proposed_salary: nil
  }

  setup %{conn: conn} do
    employer = Cen.AccountsFixtures.user_fixture(role: :employer)
    employer_not_owner = Cen.AccountsFixtures.user_fixture(role: :employer)

    %{
      conn: log_in_user(conn, employer),
      user: employer,
      conn_not_owner: log_in_user(conn, employer_not_owner)
    }
  end

  describe "create vacancy" do
    setup [:create_organization]

    test "renders vacancy when data is valid", %{conn: conn, organization: organization} do
      conn = post(conn, ~p"/api/organizations/#{organization}/new_vacancy", vacancy: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn_get = get(conn, ~p"/api/vacancies/#{id}")
      json = json_response(conn_get, 200)

      assert_schema VacancyResponse, json

      assert %{
               "id" => ^id,
               "description" => "some description",
               "education" => "none",
               "employment_type" => "main",
               "field_of_art" => "music",
               "min_years_of_work_experience" => 42,
               "proposed_salary" => 42,
               "work_schedule" => "full_time"
             } = json["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, organization: organization} do
      conn = post(conn, ~p"/api/organizations/#{organization}/new_vacancy", vacancy: @invalid_attrs)
      json = json_response(conn, 422)

      assert_schema ChangesetErrorsResponse, json
    end

    test "renders forbidden error when user not owner of organization", %{
      conn_not_owner: conn,
      organization: organization
    } do
      conn = post(conn, ~p"/api/organizations/#{organization}/new_vacancy", vacancy: @invalid_attrs)
      json = json_response(conn, 403)

      assert_schema GenericErrorResponse, json
    end
  end

  describe "update vacancy" do
    setup [:create_vacancy]

    test "renders vacancy when data is valid", %{conn: conn, vacancy: %Vacancy{id: id} = vacancy} do
      conn = patch(conn, ~p"/api/vacancies/#{vacancy}", vacancy: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn_get = get(conn, ~p"/api/vacancies/#{id}")
      json = json_response(conn_get, 200)

      assert_schema VacancyResponse, json

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "education" => "higher",
               "employment_type" => "secondary",
               "field_of_art" => "visual",
               "min_years_of_work_experience" => 43,
               "proposed_salary" => 43,
               "work_schedule" => "part_time"
             } = json["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, vacancy: vacancy} do
      conn = patch(conn, ~p"/api/vacancies/#{vacancy}", vacancy: @invalid_attrs)
      json = json_response(conn, 422)

      assert_schema ChangesetErrorsResponse, json
    end

    test "renders forbidden error when user not owner of organization", %{conn_not_owner: conn, vacancy: vacancy} do
      conn = patch(conn, ~p"/api/vacancies/#{vacancy}", vacancy: @update_attrs)
      json = json_response(conn, 403)

      assert_schema GenericErrorResponse, json
    end
  end

  describe "delete vacancy" do
    setup [:create_vacancy]

    test "deletes chosen vacancy", %{conn: conn, vacancy: vacancy} do
      conn = delete(conn, ~p"/api/vacancies/#{vacancy}")
      assert response(conn, 204)

      assert conn |> get(~p"/api/vacancies/#{vacancy}") |> response(404)
    end

    test "renders forbidden error when user not owner of organization", %{conn_not_owner: conn, vacancy: vacancy} do
      conn = delete(conn, ~p"/api/vacancies/#{vacancy}")
      json = json_response(conn, 403)

      assert_schema GenericErrorResponse, json
    end
  end

  describe "search vacancies" do
    test "list all without query", %{conn: conn} do
      vacancy_fixture(employment_type: :main, published: true)
      vacancy_fixture(employment_type: :secondary, published: true)

      conn = get(conn, ~p"/api/vacancies/search")

      json = json_response(conn, 200)

      assert_schema VacanciesQueryResponse, json
      assert length(json["data"]) == 2
    end

    test "list only published vacancies", %{conn: conn} do
      vacancy_fixture(employment_type: :main)
      vacancy_fixture(employment_type: :secondary, published: true)

      conn = get(conn, ~p"/api/vacancies/search")

      json = json_response(conn, 200)

      assert_schema VacanciesQueryResponse, json
      assert length(json["data"]) == 1
    end

    test "list only queried vacancies", %{conn: conn} do
      vacancy_fixture(employment_type: :main, published: true)
      vacancy_fixture(employment_type: :secondary, published: true)

      conn = get(conn, ~p"/api/vacancies/search?employment_types[]=main")

      json = json_response(conn, 200)

      assert_schema VacanciesQueryResponse, json
      assert length(json["data"]) == 1
    end

    test "list only vacancies that match the text query", %{conn: conn} do
      vacancy_fixture(title: "Учитель танцев", published: true)
      vacancy_fixture(published: true)

      conn = get(conn, ~p"/api/vacancies/search?text=танцы")

      json = json_response(conn, 200)

      assert_schema VacanciesQueryResponse, json
      assert length(json["data"]) == 1
    end

    test "list vacancies without salary with any filter", %{conn: conn} do
      vacancy_fixture(proposed_salary: 15_000, published: true)
      vacancy_fixture(proposed_salary: nil, published: true)

      conn = get(conn, ~p"/api/vacancies/search?preferred_salary=20000")

      json = json_response(conn, 200)

      assert_schema VacanciesQueryResponse, json
      assert length(json["data"]) == 1
    end

    test "pagination works", %{conn: conn} do
      Enum.each(1..55, fn _num -> vacancy_fixture(published: true) end)

      conn = get(conn, ~p"/api/vacancies/search")

      json = json_response(conn, 200)

      assert_schema VacanciesQueryResponse, json

      assert json["page"] == %{
               "page_number" => 1,
               "page_size" => 10,
               "total_entries" => 55,
               "total_pages" => 6
             }
    end

    test "set page size", %{conn: conn} do
      conn = get(conn, ~p"/api/vacancies/search?page_size=15")

      json = json_response(conn, 200)

      assert_schema VacanciesQueryResponse, json
      assert json["page"]["page_size"] == 15
    end

    test "set page number", %{conn: conn} do
      first_vacancy = vacancy_fixture(published: true)
      secondary_vacancy = vacancy_fixture(published: true)

      first_conn = get(conn, ~p"/api/vacancies/search?page=1&page_size=1")

      first_json = json_response(first_conn, 200)

      assert_schema VacanciesQueryResponse, first_json
      assert first_json |> Map.fetch!("data") |> Enum.at(0) |> Map.fetch!("id") == first_vacancy.id

      second_conn = get(conn, ~p"/api/vacancies/search?page=2&page_size=1")

      second_json = json_response(second_conn, 200)

      assert_schema VacanciesQueryResponse, second_json
      assert second_json |> Map.fetch!("data") |> Enum.at(0) |> Map.fetch!("id") == secondary_vacancy.id
    end
  end

  defp create_organization(%{user: user}) do
    organization = organization_fixture(employer: user)
    %{organization: organization}
  end

  defp create_vacancy(%{user: user}) do
    organization = organization_fixture(employer: user)
    vacancy = vacancy_fixture(organization: organization)
    %{vacancy: vacancy}
  end
end
