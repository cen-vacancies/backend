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
    contacts: "some contacts"
  }
  @update_attrs %{
    name: "some updated name",
    address: "some updated address",
    description: "some updated description",
    logo: "some updated logo",
    contacts: "some updated contacts"
  }
  @invalid_attrs %{name: nil, address: nil, description: nil, logo: nil, contacts: nil}

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
      conn = post(conn, ~p"/api/organizations", organization: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn_get = get(conn, ~p"/api/organizations/#{id}")
      json = json_response(conn_get, 200)

      assert_schema OrganizationResponse, json

      assert %{
               "id" => ^id,
               "address" => "some address",
               "contacts" => "some contacts",
               "description" => "some description",
               "logo" => "some logo",
               "name" => "some name"
             } = json["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/organizations", organization: @invalid_attrs)
      json = json_response(conn, 422)

      assert_schema ChangesetErrorsResponse, json

      assert json["errors"] != %{}
    end

    test "renders forbidden error when user is applicant", %{conn_applicant: conn} do
      conn = post(conn, ~p"/api/organizations", organization: @invalid_attrs)
      json = json_response(conn, 403)

      assert_schema GenericErrorResponse, json
    end
  end

  describe "update organization" do
    setup [:create_organization]

    test "renders organization when data is valid", %{conn: conn, organization: %Organization{id: id} = organization} do
      conn = patch(conn, ~p"/api/organizations/#{organization}", organization: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn_get = get(conn, ~p"/api/organizations/#{id}")
      json = json_response(conn_get, 200)

      assert_schema OrganizationResponse, json

      assert %{
               "id" => ^id,
               "address" => "some updated address",
               "contacts" => "some updated contacts",
               "description" => "some updated description",
               "logo" => "some updated logo",
               "name" => "some updated name"
             } = json["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, organization: organization} do
      conn = patch(conn, ~p"/api/organizations/#{organization}", organization: @invalid_attrs)
      json = json_response(conn, 422)

      assert_schema ChangesetErrorsResponse, json
      assert json["errors"] != %{}
    end

    test "renders forbidden error when user is not owner", %{conn_applicant: conn, organization: organization} do
      conn = patch(conn, ~p"/api/organizations/#{organization}", organization: @update_attrs)
      json = json_response(conn, 403)

      assert_schema GenericErrorResponse, json
    end
  end

  describe "delete organization" do
    setup [:create_organization]

    test "deletes chosen organization", %{conn: conn, organization: organization} do
      conn = delete(conn, ~p"/api/organizations/#{organization}")
      assert response(conn, 204)

      conn_get = get(conn, ~p"/api/organizations/#{organization}")
      assert response(conn_get, 404)
    end

    test "renders forbidden error when user is not owner", %{conn_applicant: conn, organization: organization} do
      conn = delete(conn, ~p"/api/organizations/#{organization}")
      json = json_response(conn, 403)

      assert_schema GenericErrorResponse, json
    end
  end

  defp create_organization(%{user: user}) do
    organization = organization_fixture(employer: user)
    %{organization: organization}
  end
end
