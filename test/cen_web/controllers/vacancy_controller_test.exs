defmodule CenWeb.VacancyControllerTest do
  use CenWeb.ConnCase

  import Cen.EmployersFixtures

  alias Cen.Accounts
  alias Cen.AccountsFixtures
  alias Cen.Employers.Vacancy
  alias CenWeb.Schemas.ChangesetErrorsResponse
  alias CenWeb.Schemas.VacancyResponse

  @create_attrs %{
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
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup %{conn: conn} do
    token = Accounts.create_user_api_token(AccountsFixtures.user_fixture())

    {:ok,
     conn: conn |> put_req_header("accept", "application/json") |> put_req_header("authorization", "Bearer #{token}")}
  end

  describe "create vacancy" do
    setup [:create_organization]

    test "renders vacancy when data is valid", %{conn: conn, organization: organization} do
      conn = post(conn, ~p"/api/organizations/#{organization}/vacancies", vacancy: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/organizations/#{organization}/vacancies/#{id}")
      json = json_response(conn, 200)

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
      conn = post(conn, ~p"/api/organizations/#{organization}/vacancies", vacancy: @invalid_attrs)
      json = json_response(conn, 422)

      assert_schema ChangesetErrorsResponse, json
      assert json["errors"] != %{}
    end
  end

  describe "update vacancy" do
    setup [:create_vacancy]

    test "renders vacancy when data is valid", %{conn: conn, vacancy: %Vacancy{id: id} = vacancy} do
      conn = patch(conn, ~p"/api/organizations/#{vacancy.organization_id}/vacancies/#{vacancy}", vacancy: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/organizations/#{vacancy.organization_id}/vacancies/#{id}")
      json = json_response(conn, 200)

      assert_schema VacancyResponse, json

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "education" => "higher",
               "employment_type" => "secondary",
               "field_of_art" => "visual",
               "min_years_of_work_experience" => 43,
               "proposed_salary" => 43,
               "published" => false,
               "reviewed" => false,
               "work_schedule" => "part_time"
             } = json["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, vacancy: vacancy} do
      conn = patch(conn, ~p"/api/organizations/#{vacancy.organization_id}/vacancies/#{vacancy}", vacancy: @invalid_attrs)
      json = json_response(conn, 422)

      assert_schema ChangesetErrorsResponse, json

      assert json["errors"] != %{}
    end
  end

  describe "delete vacancy" do
    setup [:create_vacancy]

    test "deletes chosen vacancy", %{conn: conn, vacancy: vacancy} do
      conn = delete(conn, ~p"/api/organizations/#{vacancy.organization_id}/vacancies/#{vacancy}")
      assert response(conn, 204)

      assert conn |> get(~p"/api/organizations/#{vacancy.organization_id}/vacancies/#{vacancy}") |> response(404)
    end
  end

  defp create_vacancy(_) do
    vacancy = vacancy_fixture()
    %{vacancy: vacancy}
  end

  defp create_organization(_) do
    organization = organization_fixture()
    %{organization: organization}
  end
end
