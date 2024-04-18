defmodule CenWeb.Schemas.Page do
  @moduledoc false

  require CenWeb.StrictAPISchema

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      page_number: %{type: :integer},
      page_size: %{type: :integer},
      total_entries: %{type: :integer},
      total_pages: %{type: :integer}
    },
    example: %{
      "page_number" => 1,
      "page_size" => 10,
      "total_entries" => 23,
      "total_pages" => 3
    }
  })
end
