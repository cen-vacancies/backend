defmodule CenWeb.Schemas.Vacancy do
  @moduledoc false

  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.Organization

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      id: %{type: :integer},
      title: %{type: :string, maxLength: 160},
      description: %{type: :string, maxLength: 2000},
      employment_types: %{
        type: :array,
        items: %OpenApiSpex.Schema{type: :string, enum: Cen.Enums.employment_types()},
        minItems: 1
      },
      work_schedules: %{
        type: :array,
        items: %OpenApiSpex.Schema{type: :string, enum: Cen.Enums.work_schedules()},
        minItems: 1
      },
      education: %{type: :string, enum: Cen.Enums.educations()},
      field_of_art: %{type: :string, enum: Cen.Enums.field_of_arts()},
      min_years_of_work_experience: %{type: :integer},
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
      "employment_types" => ["main"],
      "work_schedules" => ["full_time"],
      "education" => "bachelor",
      "field_of_art" => "other",
      "min_years_of_work_experience" => 5,
      "proposed_salary" => "20000",
      "organization" => Organization.schema().example
    }
  })
end
