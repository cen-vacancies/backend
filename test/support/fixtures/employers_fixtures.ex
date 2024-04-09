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
        contacts: "some contacts",
        description: "some description",
        logo: "some logo",
        name: "some name",
        employer: AccountsFixtures.user_fixture(role: :employer)
      })
      |> Cen.Employers.create_organization()

    organization
  end
end
