defmodule Cen.EmployersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cen.Employers` context.
  """
  alias Cen.AccountsFixtures

  @doc """
  Generate a organization.
  """
  def organization_fixture(attrs \\ %{}) do
    {:ok, organization} =
      attrs
      |> Enum.into(%{
        address: "some address",
        contacts: "some contacts",
        description: "some description",
        logo: "some logo",
        name: "some name",
        employer: AccountsFixtures.user_fixture(role: :employer)
      })
      |> Cen.Employers.create_organization()

    organization
  end

  @doc """
  Generate a vacancy.
  """
  def vacancy_fixture(attrs \\ %{}) do
    {:ok, vacancy} =
      attrs
      |> Enum.into(%{
        description: "some description",
        education: :none,
        employment_type: :main,
        field_of_art: :music,
        min_years_of_work_experience: 42,
        proposed_salary: 42,
        published: true,
        reviewed: true,
        work_schedule: :full_time,
        organization: organization_fixture()
      })
      |> Cen.Employers.create_vacancy()

    vacancy
  end
end
