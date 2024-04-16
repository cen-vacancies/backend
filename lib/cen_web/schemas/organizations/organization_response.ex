defmodule CenWeb.Schemas.OrganizationResponse do
  @moduledoc false
  alias CenWeb.Schemas.Organization

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "OrganizationResponse",
    type: :object,
    required: ~w[data]a,
    properties: %{
      data: Organization.schema()
    },
    example: %{
      "data" => Organization.schema().example
    }
  })
end
