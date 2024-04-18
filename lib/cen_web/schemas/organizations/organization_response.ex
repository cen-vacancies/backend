defmodule CenWeb.Schemas.OrganizationResponse do
  @moduledoc false
  alias CenWeb.Schemas.Organization

  require CenWeb.StrictAPISchema

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
