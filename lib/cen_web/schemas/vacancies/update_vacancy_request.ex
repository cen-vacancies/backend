# credo:disable-for-this-file Credo.Check.Design.DuplicatedCode
defmodule CenWeb.Schemas.Vacancies.UpdateVacancyRequest do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.Vacancy

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      vacancy: %{
        type: :object,
        optional: :all,
        properties: using_properties(Vacancy.schema(), remove: ~w[id organization reviewed]a)
      }
    },
    example: %{
      "vacancy" => using_example(Vacancy.schema(), remove: ~w[id organization reviewed])
    }
  })
end
