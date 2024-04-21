# credo:disable-for-this-file Credo.Check.Design.DuplicatedCode
defmodule CenWeb.Schemas.CreateVacancyRequest do
  @moduledoc false

  use CenWeb.StrictAPISchema

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      vacancy: %{
        type: :object,
        optional: [:min_years_of_work_experience, :proposed_salary],
        properties: %{
          title: %{type: :string, maximum: 255},
          description: %{type: :string, maximum: 2000},
          employment_types: %{type: :array, items: %OpenApiSpex.Schema{type: :string, enum: Cen.Enums.employment_types()}},
          work_schedules: %{type: :array, items: %OpenApiSpex.Schema{type: :string, enum: Cen.Enums.work_schedules()}},
          educations: %{type: :array, items: %OpenApiSpex.Schema{type: :string, enum: Cen.Enums.educations()}},
          field_of_art: %{type: :string, enum: Cen.Enums.field_of_arts()},
          min_years_of_work_experience: %{type: :integer, default: 0},
          proposed_salary: %{type: :integer, default: 0}
        }
      }
    },
    example: %{
      "vacancy" => %{
        "title" => "Работник",
        "description" => "Ищем очень хорошего работника!",
        "employment_types" => ["main"],
        "work_schedules" => ["full_time"],
        "educations" => ["higher"],
        "field_of_art" => "other",
        "min_years_of_work_experience" => 5,
        "proposed_salary" => "20000"
      }
    }
  })
end
