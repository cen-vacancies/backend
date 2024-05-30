defmodule CenWeb.Schemas.Interest do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.CV
  alias CenWeb.Schemas.Vacancy

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      id: %{type: :integer},
      cv: CV.schema(),
      vacancy: Vacancy.schema(),
      from: %{type: :string, enum: Cen.Enums.interest_directions()}
    },
    example: %{
      "id" => 756,
      "cv" => CV.schema().example,
      "vacancy" => Vacancy.schema().example,
      "from" => "employer"
    }
  })
end
