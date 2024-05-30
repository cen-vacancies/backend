defmodule CenWeb.Schemas.InterestsListResponse do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.Interest

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      data: %{type: :array, items: Interest.schema()}
    },
    example: %{
      "data" => [Interest.schema().example]
    }
  })
end
