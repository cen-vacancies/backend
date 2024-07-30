defmodule CenWeb.Schemas.OrganizationsListResponse do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.Organization
  alias CenWeb.Schemas.Page

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      data: %{
        type: :array,
        items: Organization.schema()
      },
      page: Page.schema()
    },
    example: %{
      "data" => [Organization.schema().example],
      "page" => Page.schema().example
    }
  })
end
