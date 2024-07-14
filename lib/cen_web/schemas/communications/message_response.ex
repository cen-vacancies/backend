defmodule CenWeb.Schemas.MessageResponse do
  @moduledoc false
  use CenWeb.StrictAPISchema

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      id: %{type: :integer},
      text: %{type: :string},
      author_id: %{type: :integer},
      created_at: %{type: :string, format: :datetime}
    },
    example: %{
      "id" => 1,
      "author_id" => 1,
      "text" => "I am interested in this vacancy",
      "created_at" => "2021-01-01T00:00:00Z"
    }
  })
end
