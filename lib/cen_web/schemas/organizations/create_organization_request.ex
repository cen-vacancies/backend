defmodule CenWeb.Schemas.CreateOrganizationRequest do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.Organization

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      organization: %{
        type: :object,
        optional: ~w[address logo email website social_link]a,
        properties: using_properties(Organization.schema(), remove: ~w[id employer]a)
      }
    },
    example: %{
      "organization" => using_example(Organization.schema(), remove: ~w[id employer])
    }
  })
end
