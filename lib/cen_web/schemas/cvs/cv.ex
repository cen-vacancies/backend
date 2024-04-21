defmodule CenWeb.Schemas.CV do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.User

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      id: %{type: :integer},
      title: %{type: :string, maximum: 255},
      summary: %{type: :string, maximum: 2000},
      published: %{type: :boolean},
      reviewed: %{type: :boolean},
      employment_types: %{type: :array, items: %{type: :string, enum: Cen.Enums.employment_types()}},
      work_schedules: %{type: :array, items: %{type: :string, enum: Cen.Enums.work_schedules()}},
      field_of_art: %{type: :string, enum: Cen.Enums.field_of_arts()},
      years_of_work_experience: %{type: :integer},
      applicant: User.schema(),
      educations: %{
        type: :array,
        items: %{
          type: :object,
          optional: ~w[educational_institution department specialization year_of_graduation],
          properties: %{
            level: %{type: :string, enum: Cen.Enums.educations()},
            educational_institution: %{type: :string, nullable: true},
            department: %{type: :string, nullable: true},
            specialization: %{type: :string, nullable: true},
            year_of_graduation: %{type: :integer, nullable: true}
          }
        }
      }
    },
    example: %{
      "id" => 521,
      "title" => "Педагог по фортепиано",
      "summary" => "Я очень хорошо играю на фортепиано.",
      "published" => true,
      "reviewed" => true,
      "employment_types" => ["main"],
      "work_schedules" => ["full_time"],
      "field_of_art" => "music",
      "years_of_work_experience" => 4,
      "applicant" => User.schema().example,
      "educations" => [
        %{
          "level" => :secondary,
          "educational_institution" => "УрФУ",
          "department" => nil,
          "specialization" => "Архитектура зданий и сооружений. Творческие концепции архитектурной деятельности",
          "year_of_graduation" => "2024"
        }
      ]
    }
  })
end
