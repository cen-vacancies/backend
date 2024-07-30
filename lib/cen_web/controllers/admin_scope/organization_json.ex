defmodule CenWeb.AdminScope.OrganizationJSON do
  @moduledoc false

  alias CenWeb.OrganizationJSON
  alias CenWeb.PageJSON

  @doc """
  Renders a list of organizations.
  """
  def index(%{page: %{entries: organizations} = page}) do
    %{data: for(organization <- organizations, do: data(organization)), page: PageJSON.show(page)}
  end

  defp data(organization), do: OrganizationJSON.data(organization)
end
