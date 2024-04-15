defmodule CenWeb.Schemas.Vacancy do
  @moduledoc false
  alias Cen.Employers.Vacancy
  alias CenWeb.Schemas.Organization
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Vacancy",
    type: :object,
    required:
      ~w[id title description employment_type work_schedule education field_of_art min_years_of_work_experience organization]a,
    properties: %{
      id: %Schema{type: :integer},
      title: %Schema{type: :string},
      description: %Schema{type: :string},
      employment_type: %Schema{type: :string, enum: Vacancy.employment_types()},
      work_schedule: %Schema{type: :string, enum: Vacancy.work_schedules()},
      education: %Schema{type: :string, enum: Vacancy.educations()},
      field_of_art: %Schema{type: :string, enum: Vacancy.field_of_arts()},
      min_years_of_work_experience: %Schema{type: :integer, default: 0},
      proposed_salary: %Schema{type: :integer, default: 0},
      organization: Organization.schema()
    },
    example: %{
      "id" => "756",
      "title" => "Работник",
      "description" => "Ищем очень хорошего работника!",
      "employment_type" => "main",
      "work_schedule" => "full_time",
      "education" => "higher",
      "field_of_art" => "other",
      "min_years_of_work_experience" => 5,
      "proposed_salary" => "20000",
      "organization" => Organization.schema().example
    }
  })
end
