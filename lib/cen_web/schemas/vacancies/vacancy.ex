defmodule CenWeb.Schemas.Vacancy do
  @moduledoc false
  alias Cen.Employers.Vacancy
  alias CenWeb.Schemas.Organization

  require CenWeb.StrictAPISchema

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      id: %{type: :integer},
      title: %{type: :string},
      description: %{type: :string},
      employment_type: %{type: :string, enum: Vacancy.employment_types()},
      work_schedule: %{type: :string, enum: Vacancy.work_schedules()},
      education: %{type: :string, enum: Vacancy.educations()},
      field_of_art: %{type: :string, enum: Vacancy.field_of_arts()},
      min_years_of_work_experience: %{type: :integer, default: 0},
      proposed_salary: %{type: :integer, nullable: true},
      published: %{type: :boolean},
      reviewed: %{type: :boolean},
      organization: Organization.schema()
    },
    example: %{
      "id" => "756",
      "published" => true,
      "reviewed" => true,
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
