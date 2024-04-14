defmodule CenWeb.Schemas.Vacancies.VacanciesQueryResponse do
  @moduledoc false
  alias CenWeb.Schemas.Vacancy
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Vacancy response",
    type: :object,
    required: ~w[data]a,
    properties: %{
      data: %Schema{
        type: :array,
        items: Vacancy.schema()
      }
    },
    example: %{
      "data" => [Vacancy.schema().example]
    }
  })
end
