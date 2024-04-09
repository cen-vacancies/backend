defmodule CenWeb.OrganizationControllerTest do
  use CenWeb.ConnCase

  import Cen.EmployersFixtures

  alias Cen.Employers.Organization
  alias CenWeb.Schemas.ChangesetErrorsResponse
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

  setup :register_and_log_in_user

  describe "create organization" do
    test "renders organization when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/organizations", organization: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/organizations/#{id}")
      json = json_response(conn, 200)

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
  end

  describe "update organization" do
    setup [:create_organization]

    test "renders organization when data is valid", %{conn: conn, organization: %Organization{id: id} = organization} do
      conn = patch(conn, ~p"/api/organizations/#{organization}", organization: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/organizations/#{id}")
      json = json_response(conn, 200)

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
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete organization" do
    setup [:create_organization]

    test "deletes chosen organization", %{conn: conn, organization: organization} do
      conn = delete(conn, ~p"/api/organizations/#{organization}")
      assert response(conn, 204)

      conn = get(conn, ~p"/api/organizations/#{organization}")
      assert response(conn, 404)
    end
  end

  defp create_organization(_) do
    organization = organization_fixture()
    %{organization: organization}
  end
end
