defmodule CenWeb.OrganizationControllerTest do
  use CenWeb.ConnCase

  import Cen.EmployersFixtures

  alias Cen.Accounts
  alias Cen.AccountsFixtures
  alias Cen.Employers.Organization

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
    token = Accounts.create_user_api_token(AccountsFixtures.user_fixture())

    {:ok,
     conn: conn |> put_req_header("accept", "application/json") |> put_req_header("authorization", "Bearer #{token}")}
  end

  describe "create organization" do
    test "renders organization when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/organizations", organization: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/organizations/#{id}")

      assert %{
               "id" => ^id,
               "address" => "some address",
               "contacts" => "some contacts",
               "description" => "some description",
               "logo" => "some logo",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/organizations", organization: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update organization" do
    setup [:create_organization]

    test "renders organization when data is valid", %{conn: conn, organization: %Organization{id: id} = organization} do
      conn = patch(conn, ~p"/api/organizations/#{organization}", organization: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/organizations/#{id}")

      assert %{
               "id" => ^id,
               "address" => "some updated address",
               "contacts" => "some updated contacts",
               "description" => "some updated description",
               "logo" => "some updated logo",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
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