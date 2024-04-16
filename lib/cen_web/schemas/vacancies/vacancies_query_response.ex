defmodule CenWeb.Schemas.Vacancies.VacanciesQueryResponse do
  @moduledoc false
  alias CenWeb.Schemas.Page
  alias CenWeb.Schemas.Vacancy
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "VacanciesQueryResponse",
    type: :object,
    required: ~w[data]a,
    properties: %{
      data: %Schema{
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
