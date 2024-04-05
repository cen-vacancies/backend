defmodule CenWeb.OrganizationJSON do
  alias Cen.Employers.Organization

  @doc """
  Renders a list of organizations.
  """
  def index(%{organizations: organizations}) do
    %{data: for(organization <- organizations, do: data(organization))}
  end

  @doc """
  Renders a single organization.
  """
  def show(%{organization: organization}) do
    %{data: data(organization)}
  end

  defp data(%Organization{} = organization) do
    %{
      id: organization.id,
      name: organization.name,
      logo: organization.logo,
      description: organization.description,
      address: organization.address,
      contacts: organization.contacts
    }
  end
end
