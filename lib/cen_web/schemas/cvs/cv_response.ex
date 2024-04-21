defmodule CenWeb.Schemas.CVResponse do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.CV

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      data: CV.schema()
    },
    example: %{
      "data" => CV.schema().example
    }
  })
end
