defmodule CenWeb.InterestControllerTest do
  use CenWeb.ConnCase

  import Cen.ApplicantsFixtures
  import Cen.EmployersFixtures

  alias CenWeb.Schemas.ChangesetErrorsResponse
  alias CenWeb.Schemas.InterestResponse

  setup %{conn: conn} do
    employer = Cen.AccountsFixtures.user_fixture(role: :employer)
    organization = organization_fixture(employer: employer)
    vacancy = vacancy_fixture(organization: organization)

    applicant = Cen.AccountsFixtures.user_fixture(role: :applicant)
    cv = cv_fixture(applicant: applicant)

    %{
      conn_employer: log_in_user(conn, employer),
      conn_applicant: log_in_user(conn, applicant),
      cv: cv,
      vacancy: vacancy
    }
  end

  describe "POST /api/send_interest" do
    test "sends from employer to applicant", %{conn_employer: conn, cv: cv, vacancy: vacancy} do
      conn = post(conn, "/api/send_interest", %{cv_id: cv.id, vacancy_id: vacancy.id})

      assert json = json_response(conn, 200)
      assert json["data"]["from"] == "employer"
      assert_schema InterestResponse, json
    end

    test "sends from applicant to employer", %{conn_applicant: conn, cv: cv, vacancy: vacancy} do
      conn = post(conn, "/api/send_interest", %{cv_id: cv.id, vacancy_id: vacancy.id})

      assert json = json_response(conn, 200)
      assert json["data"]["from"] == "applicant"
      assert_schema InterestResponse, json
    end

    test "returns error on second interest", %{conn_applicant: conn, cv: cv, vacancy: vacancy} do
      post(conn, "/api/send_interest", %{cv_id: cv.id, vacancy_id: vacancy.id})

      conn = post(conn, "/api/send_interest", %{cv_id: cv.id, vacancy_id: vacancy.id})

      assert json = json_response(conn, 422)
      assert_schema ChangesetErrorsResponse, json
    end
  end
end
