defmodule CenWeb.Schemas.Vacancies.VacanciesQueryResponse do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.Page
  alias CenWeb.Schemas.Vacancy

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      data: %{
        type: :array,
        items: Vacancy.schema()
      },
      page: Page.schema()
    },
    example: %{
      "data" => [Vacancy.schema().example],
      "page" => Page.schema().example
    }
  })
end
