defmodule CenWeb.Schemas.Chat do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.CV
  alias CenWeb.Schemas.Vacancy

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      id: %{type: :integer},
      cv: CV.schema(),
      vacancy: Vacancy.schema()
    },
    example: %{
      "id" => 756,
      "cv" => CV.schema().example,
      "vacancy" => Vacancy.schema().example
    }
  })
end
