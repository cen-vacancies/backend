defmodule CenWeb.Schemas.SendInterestRequest do
  @moduledoc false
  use CenWeb.StrictAPISchema

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      cv_id: %{type: :integer},
      vacancy_id: %{type: :integer}
    },
    example: %{
      "cv_id" => 612,
      "vacancy_id" => 219
    }
  })
end
