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

    test "fetch_organization/1 returns {:error, :not_found} if id is invalid" do
      assert {:error, :not_found} = Employers.fetch_organization(-1)
    end

    test "fetch_organization/1 returns the organization with the given id" do
      %{id: id} = organization = organization_fixture()
      assert {:ok, %Organization{id: ^id}} = Employers.fetch_organization(organization.id)
    end

    test "create_organization/1 with valid data creates a organization" do
      valid_attrs = %{
        name: "some name",
        address: "some address",
        description: "some description",
        logo: "some logo",
        employer: AccountsFixtures.user_fixture()
      }

      assert {:ok, %Organization{} = organization} = Employers.create_organization(valid_attrs)
      assert organization.name == "some name"
      assert organization.address == "some address"
      assert organization.description == "some description"
      assert organization.logo == "some logo"
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
        logo: "some updated logo"
      }

      assert {:ok, %Organization{} = organization} = Employers.update_organization(organization, update_attrs)
      assert organization.name == "some updated name"
      assert organization.address == "some updated address"
      assert organization.description == "some updated description"
      assert organization.logo == "some updated logo"
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

  describe "vacancies" do
    import Cen.EmployersFixtures

    alias Cen.Employers.Vacancy

    setup context do
      Map.put(context, :invalid_attrs, %{
        description: nil,
        published: nil,
        reviewed: nil,
        employment_type: nil,
        work_schedule: nil,
        education: nil,
        field_of_art: nil,
        min_years_of_work_experience: nil,
        proposed_salary: nil,
        organization: organization_fixture()
      })
    end

    test "list_vacancies/0 returns all vacancies" do
      vacancy = vacancy_fixture()
      assert Employers.list_vacancies() == [vacancy]
    end

    test "get_vacancy!/1 returns the vacancy with given id" do
      vacancy = vacancy_fixture()
      assert Employers.get_vacancy!(vacancy.id) == vacancy
    end

    test "create_vacancy/1 with valid data creates a vacancy" do
      valid_attrs = %{
        title: "title",
        description: "some description",
        employment_types: [:main],
        work_schedules: [:full_time],
        educations: [:none],
        field_of_art: :music,
        min_years_of_work_experience: 42,
        proposed_salary: 42,
        organization: organization_fixture()
      }

      assert {:ok, %Vacancy{} = vacancy} = Employers.create_vacancy(valid_attrs)
      assert vacancy.description == "some description"
      assert vacancy.employment_types == [:main]
      assert vacancy.work_schedules == [:full_time]
      assert vacancy.educations == [:none]
      assert vacancy.field_of_art == :music
      assert vacancy.min_years_of_work_experience == 42
      assert vacancy.proposed_salary == 42
    end

    test "create_vacancy/1 with invalid data returns error changeset", %{invalid_attrs: invalid_attrs} do
      assert {:error, %Ecto.Changeset{}} = Employers.create_vacancy(invalid_attrs)
    end

    test "create_vacancy/1 with empty arrays return error changeset" do
      attrs = %{
        title: "title",
        description: "some description",
        employment_types: [],
        work_schedules: [],
        educations: [],
        field_of_art: :music,
        min_years_of_work_experience: 42,
        proposed_salary: 42,
        organization: organization_fixture()
      }

      assert {:error, %Ecto.Changeset{}} = Employers.create_vacancy(attrs)
    end

    test "update_vacancy/2 with valid data updates the vacancy" do
      vacancy = vacancy_fixture()

      update_attrs = %{
        description: "some updated description",
        published: false,
        reviewed: false,
        employment_types: [:secondary],
        work_schedules: [:part_time],
        educations: [:bachelor],
        field_of_art: :visual,
        min_years_of_work_experience: 43,
        proposed_salary: 43
      }

      assert {:ok, %Vacancy{} = vacancy} = Employers.update_vacancy(vacancy, update_attrs)
      assert vacancy.description == "some updated description"
      assert vacancy.published == false
      assert vacancy.reviewed == true
      assert vacancy.employment_types == [:secondary]
      assert vacancy.work_schedules == [:part_time]
      assert vacancy.educations == [:bachelor]
      assert vacancy.field_of_art == :visual
      assert vacancy.min_years_of_work_experience == 43
      assert vacancy.proposed_salary == 43
    end

    test "update_vacancy/2 with invalid data returns error changeset", %{invalid_attrs: invalid_attrs} do
      vacancy = vacancy_fixture()
      assert {:error, %Ecto.Changeset{}} = Employers.update_vacancy(vacancy, invalid_attrs)
      assert vacancy == Employers.get_vacancy!(vacancy.id)
    end

    test "delete_vacancy/1 deletes the vacancy" do
      vacancy = vacancy_fixture()
      assert {:ok, %Vacancy{}} = Employers.delete_vacancy(vacancy)
      assert_raise Ecto.NoResultsError, fn -> Employers.get_vacancy!(vacancy.id) end
    end

    test "change_vacancy/1 returns a vacancy changeset" do
      vacancy = vacancy_fixture()
      assert %Ecto.Changeset{} = Employers.change_vacancy(vacancy)
    end
  end
end
