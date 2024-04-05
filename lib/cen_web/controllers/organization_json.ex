defmodule CenWeb.OrganizationJSON do
  alias Cen.Employers.Organization
  alias CenWeb.UserJSON

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

  def data(%Organization{} = organization) do
    %{
      id: organization.id,
      name: organization.name,
      logo: organization.logo,
      description: organization.description,
      address: organization.address,
      contacts: organization.contacts,
      employer: UserJSON.data(organization.employer)
    }
  end
end
