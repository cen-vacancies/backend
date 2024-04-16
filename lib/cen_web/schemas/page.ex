defmodule CenWeb.Schemas.Page do
  @moduledoc false
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Page",
    type: :object,
    required: ~w[page_number page_size total_entries total_pages]a,
    properties: %{
      page_number: %Schema{type: :integer},
      page_size: %Schema{type: :integer},
      total_entries: %Schema{type: :integer},
      total_pages: %Schema{type: :integer}
    },
    example: %{
      "page_number" => 1,
      "page_size" => 10,
      "total_entries" => 23,
      "total_pages" => 3
    }
  })
end
