defmodule CenWeb.Schemas.VacancyResponse do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.Vacancy

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      data: Vacancy.schema()
    },
    example: %{
      "data" => Vacancy.schema().example
    }
  })
end
