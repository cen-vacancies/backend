defmodule CenWeb.Schemas.OrganizationResponse do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.Organization

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      data: Organization.schema()
    },
    example: %{
      "data" => Organization.schema().example
    }
  })
end
