defmodule CenWeb.Schemas.UsersListResponse do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.Page
  alias CenWeb.Schemas.User

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      data: %{
        type: :array,
        items: User.schema()
      },
      page: Page.schema()
    },
    example: %{
      "data" => [User.schema().example],
      "page" => Page.schema().example
    }
  })
end
