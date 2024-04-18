defmodule CenWeb.Schemas.VacancyResponse do
  @moduledoc false
  alias CenWeb.Schemas.Vacancy

  require CenWeb.StrictAPISchema

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
