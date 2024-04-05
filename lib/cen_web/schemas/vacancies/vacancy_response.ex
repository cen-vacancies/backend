defmodule CenWeb.Schemas.VacancyResponse do
  @moduledoc false
  alias CenWeb.Schemas.Vacancy

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Vacancy response",
    type: :object,
    required:
      ~w[data]a,
    properties: %{
      data: Vacancy.schema()
    },
    example: %{
      "data" => Vacancy.schema().example
    }
  })
end
