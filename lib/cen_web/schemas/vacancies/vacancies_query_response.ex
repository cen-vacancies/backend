defmodule CenWeb.Schemas.Vacancies.VacanciesQueryResponse do
  @moduledoc false
  alias CenWeb.Schemas.Page
  alias CenWeb.Schemas.Vacancy

  require CenWeb.StrictAPISchema

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
