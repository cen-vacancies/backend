# credo:disable-for-this-file Credo.Check.Design.DuplicatedCode
defmodule CenWeb.Schemas.CreateVacancyRequest do
  @moduledoc false
  alias Cen.Employers.Vacancy

  require CenWeb.StrictAPISchema

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      vacancy: %{
        type: :object,
        optional: [:min_years_of_work_experience, :proposed_salary],
        properties: %{
          title: %{type: :string, maximum: 255},
          description: %{type: :string, maximum: 2000},
          employment_type: %{type: :string, enum: Vacancy.employment_types()},
          work_schedule: %{type: :string, enum: Vacancy.work_schedules()},
          education: %{type: :string, enum: Vacancy.educations()},
          field_of_art: %{type: :string, enum: Vacancy.field_of_arts()},
          min_years_of_work_experience: %{type: :integer, default: 0},
          proposed_salary: %{type: :integer, default: 0}
        }
      }
    },
    example: %{
      "vacancy" => %{
        "title" => "Работник",
        "description" => "Ищем очень хорошего работника!",
        "employment_type" => "main",
        "work_schedule" => "full_time",
        "education" => "higher",
        "field_of_art" => "other",
        "min_years_of_work_experience" => 5,
        "proposed_salary" => "20000"
      }
    }
  })
end
