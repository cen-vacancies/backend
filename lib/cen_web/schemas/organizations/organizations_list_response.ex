defmodule CenWeb.Schemas.OrganizationsListResponse do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.Organization
  alias CenWeb.Schemas.Utils

  Organization
  |> Utils.list_of()
  |> CenWeb.StrictAPISchema.schema()
end
