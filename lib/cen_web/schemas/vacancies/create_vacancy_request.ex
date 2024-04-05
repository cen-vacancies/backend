defmodule CenWeb.Schemas.CreateVacancyRequest do
  @moduledoc false
  alias Cen.Employers.Vacancy
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Vacancy params",
    type: :object,
    required: ~w[vacancy]a,
    properties: %{
      vacancy: %Schema{
        required: ~w[description employment_type work_schedule education field_of_art organization_id]a,
        properties: %{
          description: %Schema{type: :string},
          employment_type: %Schema{type: :string, enum: Vacancy.employment_types()},
          work_schedule: %Schema{type: :string, enum: Vacancy.work_schedules()},
          education: %Schema{type: :string, enum: Vacancy.educations()},
          field_of_art: %Schema{type: :string, enum: Vacancy.field_of_arts()},
          min_years_of_work_experience: %Schema{type: :integer, default: 0},
          proposed_salary: %Schema{type: :integer, default: 0},
          organization_id: %Schema{type: :integer},
        }
      }
    },
    example: %{
      "vacancy" => %{
        "description" => "Ищем очень хорошего работника!",
        "employment_type" => "main",
        "work_schedule" => "full_time",
        "education" => "higher",
        "field_of_art" => "other",
        "min_years_of_work_experience" => 5,
        "proposed_salary" => "20000",
        "organization_id" => 100
      }
    }
  })
end
