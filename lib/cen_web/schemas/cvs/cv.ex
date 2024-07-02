defmodule CenWeb.Schemas.CV do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.User

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      id: %{type: :integer},
      title: %{type: :string, maxLength: 160},
      summary: %{type: :string, maxLength: 2000},
      published: %{type: :boolean},
      reviewed: %{type: :boolean},
      photo: %{type: :string},
      employment_types: %{type: :array, minItems: 1, items: %{type: :string, enum: Cen.Enums.employment_types()}},
      work_schedules: %{type: :array, minItems: 1, items: %{type: :string, enum: Cen.Enums.work_schedules()}},
      field_of_art: %{type: :string, enum: Cen.Enums.field_of_arts()},
      applicant: User.schema(),
      educations: %{
        type: :array,
        minItems: 1,
        items: %{
          type: :object,
          optional: ~w[department],
          properties: %{
            level: %{type: :string, enum: Cen.Enums.cv_educations()},
            educational_institution: %{type: :string, maxLength: 160, nullable: true},
            department: %{type: :string, maxLength: 160, nullable: true},
            specialization: %{type: :string, maxLength: 160, nullable: true},
            year_of_graduation: %{type: :integer, nullable: true}
          }
        }
      },
      jobs: %{
        type: :array,
        items: %{
          type: :object,
          optional: ~w[organization_name job_title description]a,
          properties: %{
            organization_name: %{type: :string, maxLength: 160, nullable: true},
            job_title: %{type: :string, maxLength: 160, nullable: true},
            description: %{type: :string, maxLength: 1000, nullable: true},
            start_date: %{type: :string, format: :date, description: "day should be ignored"},
            end_date: %{type: :string, format: :date, description: "day should be ignored"}
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
      "applicant" => User.schema().example,
      "photo" => "/uploads/photo.png",
      "educations" => [
        %{
          "level" => :secondary,
          "educational_institution" => "УрФУ",
          "department" => nil,
          "specialization" => "Архитектура зданий и сооружений. Творческие концепции архитектурной деятельности",
          "year_of_graduation" => 2024
        }
      ],
      "jobs" => [
        %{
          "organization_name" => "УрФУ",
          "job_title" => "Преподаватель",
          "description" => "Преподавал предмет",
          "start_date" => "2022-12-01",
          "end_date" => "2024-02-01"
        }
      ]
    }
  })
end
