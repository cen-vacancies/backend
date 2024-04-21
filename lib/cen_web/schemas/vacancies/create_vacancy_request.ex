# credo:disable-for-this-file Credo.Check.Design.DuplicatedCode
defmodule CenWeb.Schemas.CreateVacancyRequest do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.Vacancy

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      vacancy: %{
        type: :object,
        optional: [:min_years_of_work_experience, :proposed_salary, :published],
        properties: using_properties(Vacancy.schema(), remove: ~w[id organization reviewed]a)
      }
    },
    example: %{
      "vacancy" => using_example(Vacancy.schema(), remove: ~w[id organization reviewed])
    }
  })
end
