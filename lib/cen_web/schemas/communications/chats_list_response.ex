defmodule CenWeb.Schemas.ChatsListResponse do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.Chat
  alias CenWeb.Schemas.Page

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      data: %{type: :array, items: Chat.schema()},
      page: Page.schema()
    },
    example: %{
      "data" => [Chat.schema().example],
      "page" => Page.schema().example
    }
  })
end
