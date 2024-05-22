defmodule CenWeb.OrganizationControllerTest do
  use CenWeb.ConnCase

  import Cen.EmployersFixtures

  alias Cen.Employers.Organization
  alias CenWeb.Schemas.ChangesetErrorsResponse
  alias CenWeb.Schemas.GenericErrorResponse
  alias CenWeb.Schemas.OrganizationResponse

  @create_attrs %{
    name: "some name",
    address: "some address",
    description: "some description",
    logo: "some logo",
    phone: "some phone",
    email: "some email",
    website: "some website",
    social_link: "some social_link"
  }
  @update_attrs %{
    name: "some updated name",
    address: "some updated address",
    description: "some updated description",
    logo: "some updated logo",
    phone: "some updated phone",
    email: "some updated email",
    website: "some updated website",
    social_link: "some updated social_link"
  }
  @invalid_attrs %{name: nil, address: nil, description: nil, logo: nil}

  setup %{conn: conn} do
    employer = Cen.AccountsFixtures.user_fixture(role: :employer)
    applicant = Cen.AccountsFixtures.user_fixture(role: :applicant)

    %{
      conn: log_in_user(conn, employer),
      user: employer,
      conn_applicant: log_in_user(conn, applicant)
    }
  end

  describe "create organization" do
    test "renders organization when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/organization", organization: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn_get = get(conn, ~p"/api/organization")
      json = json_response(conn_get, 200)

      assert_schema OrganizationResponse, json

      assert %{
               "id" => ^id,
               "address" => "some address",
               "description" => "some description",
               "logo" => "some logo",
               "name" => "some name"
             } = json["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/organization", organization: @invalid_attrs)
      json = json_response(conn, 422)

      assert_schema ChangesetErrorsResponse, json
    end

    test "renders forbidden error when user is applicant", %{conn_applicant: conn} do
      conn = post(conn, ~p"/api/organization", organization: @invalid_attrs)
      json = json_response(conn, 403)

      assert_schema GenericErrorResponse, json
    end
  end

  describe "show organization by id" do
    setup [:create_organization]

    test "renders organization", %{conn: conn, organization: %Organization{id: id}} do
      conn = get(conn, ~p"/api/organizations/#{id}")
      json = json_response(conn, 200)

      assert_schema OrganizationResponse, json

      assert %{
               "id" => ^id,
               "address" => "some address",
               "description" => "some description",
               "logo" => "some logo",
               "name" => "some name"
             } = json["data"]
    end
  end

  describe "update organization" do
    setup [:create_organization]

    test "renders organization when data is valid", %{conn: conn, organization: %Organization{id: id} = organization} do
      conn = patch(conn, ~p"/api/organization", organization: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn_get = get(conn, ~p"/api/organizations/#{id}")
      json = json_response(conn_get, 200)

      assert_schema OrganizationResponse, json
    end

    test "renders errors when data is invalid", %{conn: conn, organization: organization} do
      conn = patch(conn, ~p"/api/organization", organization: @invalid_attrs)
      json = json_response(conn, 422)

      assert_schema ChangesetErrorsResponse, json
    end

    test "renders not found error when user hasn't organization", %{conn_applicant: conn, organization: organization} do
      conn = patch(conn, ~p"/api/organization", organization: @update_attrs)
      json = json_response(conn, 404)

      assert_schema GenericErrorResponse, json
    end
  end

  describe "delete organization" do
    setup [:create_organization]

    test "deletes chosen organization", %{conn: conn, organization: organization} do
      conn = delete(conn, ~p"/api/organization")
      assert response(conn, 204)

      conn_get = get(conn, ~p"/api/organization")
      assert response(conn_get, 404)
    end

    test "renders not found error when user hasn't organization", %{conn_applicant: conn, organization: organization} do
      conn = delete(conn, ~p"/api/organization")
      json = json_response(conn, 404)

      assert_schema GenericErrorResponse, json
    end
  end

  defp create_organization(%{user: user}) do
    organization = organization_fixture(employer: user)
    %{organization: organization}
  end
end
