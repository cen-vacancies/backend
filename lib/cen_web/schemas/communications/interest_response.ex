defmodule CenWeb.Schemas.InterestResponse do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.Interest

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      data: Interest.schema()
    },
    example: %{
      "data" => Interest.schema().example
    }
  })
end
