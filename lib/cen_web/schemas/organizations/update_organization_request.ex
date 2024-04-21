defmodule CenWeb.Schemas.Organizations.UpdateOrganizationRequest do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.Organization

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      organization: %{
        type: :object,
        optional: :all,
        properties: using_properties(Organization.schema(), remove: ~w[id employer])
      }
    },
    example: %{
      "organization" => using_example(Organization.schema(), remove: ~w[id employer])
    }
  })
end
