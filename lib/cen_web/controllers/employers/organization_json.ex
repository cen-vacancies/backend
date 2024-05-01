defmodule CenWeb.OrganizationJSON do
  alias Cen.Employers.Organization
  alias CenWeb.UserJSON

  @doc """
  Renders a single organization.
  """
  @spec show(map()) :: map()
  def show(%{organization: organization}) do
    %{data: data(organization)}
  end

  @spec data(Organization.t()) :: map()
  def data(%Organization{} = organization) do
    %{
      id: organization.id,
      name: organization.name,
      logo: organization.logo,
      description: organization.description,
      address: organization.address,
      phone: organization.phone,
      email: organization.email,
      website: organization.website,
      social_link: organization.social_link,
      employer: UserJSON.data(organization.employer)
    }
  end
end
