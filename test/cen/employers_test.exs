defmodule Cen.EmployersTest do
  use Cen.DataCase

  alias Cen.AccountsFixtures
  alias Cen.Employers

  describe "organizations" do
    import Cen.EmployersFixtures

    alias Cen.Employers.Organization

    setup context do
      Map.put(context, :invalid_attrs, %{
        name: nil,
        address: nil,
        description: nil,
        logo: nil,
        contacts: nil,
        employer: AccountsFixtures.user_fixture()
      })
    end

    test "list_organizations/0 returns all organizations" do
      organization = organization_fixture()
      assert Employers.list_organizations() == [organization]
    end

    test "get_organization!/1 returns the organization with given id" do
      organization = organization_fixture()
      assert Employers.get_organization!(organization.id) == organization
    end

    test "create_organization/1 with valid data creates a organization" do
      valid_attrs = %{
        name: "some name",
        address: "some address",
        description: "some description",
        logo: "some logo",
        contacts: "some contacts",
        employer: AccountsFixtures.user_fixture()
      }

      assert {:ok, %Organization{} = organization} = Employers.create_organization(valid_attrs)
      assert organization.name == "some name"
      assert organization.address == "some address"
      assert organization.description == "some description"
      assert organization.logo == "some logo"
      assert organization.contacts == "some contacts"
    end

    test "create_organization/1 with invalid data returns error changeset", %{invalid_attrs: invalid_attrs} do
      assert {:error, %Ecto.Changeset{}} = Employers.create_organization(invalid_attrs)
    end

    test "update_organization/2 with valid data updates the organization" do
      organization = organization_fixture()

      update_attrs = %{
        name: "some updated name",
        address: "some updated address",
        description: "some updated description",
        logo: "some updated logo",
        contacts: "some updated contacts"
      }

      assert {:ok, %Organization{} = organization} = Employers.update_organization(organization, update_attrs)
      assert organization.name == "some updated name"
      assert organization.address == "some updated address"
      assert organization.description == "some updated description"
      assert organization.logo == "some updated logo"
      assert organization.contacts == "some updated contacts"
    end

    test "update_organization/2 with invalid data returns error changeset", %{invalid_attrs: invalid_attrs} do
      organization = organization_fixture()
      assert {:error, %Ecto.Changeset{}} = Employers.update_organization(organization, invalid_attrs)
      assert organization == Employers.get_organization!(organization.id)
    end

    test "delete_organization/1 deletes the organization" do
      organization = organization_fixture()
      assert {:ok, %Organization{}} = Employers.delete_organization(organization)
      assert_raise Ecto.NoResultsError, fn -> Employers.get_organization!(organization.id) end
    end

    test "change_organization/1 returns a organization changeset" do
      organization = organization_fixture()
      assert %Ecto.Changeset{} = Employers.change_organization(organization)
    end
  end
end
