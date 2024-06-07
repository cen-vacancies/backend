# credo:disable-for-this-file Credo.Check.Readability.Specs
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
        phone: "some phone",
        email: "some email",
        website: "some website",
        social_link: "some social_link",
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
        title: "some title",
        description: "some description",
        education: :secondary,
        employment_types: [:main, :secondary],
        field_of_art: :music,
        min_years_of_work_experience: 42,
        proposed_salary: 42,
        work_schedules: [:full_time],
        organization: organization_fixture()
      })
      |> Cen.Employers.create_vacancy()

    vacancy
  end
end
