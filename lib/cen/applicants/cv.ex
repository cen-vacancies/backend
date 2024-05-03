defmodule Cen.Applicants.CV do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias Cen.Accounts.User

  @type t :: %__MODULE__{
          id: integer() | nil,
          published: boolean(),
          reviewed: boolean(),
          summary: String.t() | nil,
          employment_types: atom() | nil,
          work_schedules: atom() | nil,
          field_of_art: atom() | nil,
          applicant_id: integer() | nil,
          applicant: User.t() | Ecto.Association.NotLoaded.t(),
          educations: [education],
          jobs: [job]
        }

  @type education :: %__MODULE__.Education{
          level: atom(),
          educational_institution: String.t(),
          department: String.t(),
          specialization: String.t(),
          year_of_graduation: integer()
        }

  @type job :: %__MODULE__.Job{
          organization_name: String.t() | nil,
          job_title: String.t() | nil,
          description: String.t() | nil,
          start_date: Date.t() | nil,
          end_date: Date.t() | nil
        }

  schema "applicants_cvs" do
    field :title, :string
    field :summary, :string
    field :published, :boolean, default: false
    field :reviewed, :boolean, default: false
    field :employment_types, {:array, Ecto.Enum}, values: Cen.Enums.employment_types()
    field :work_schedules, {:array, Ecto.Enum}, values: Cen.Enums.work_schedules()
    field :field_of_art, Ecto.Enum, values: Cen.Enums.field_of_arts()

    field :photo, :string, default: "/images/no_photo.jpg"

    embeds_many :educations, Education, on_replace: :delete do
      field :level, Ecto.Enum, values: Cen.Enums.cv_educations()
      field :educational_institution, :string, default: nil
      field :department, :string, default: nil
      field :specialization, :string, default: nil
      field :year_of_graduation, :integer, default: nil
    end

    embeds_many :jobs, Job, on_replace: :delete do
      field :organization_name, :string
      field :job_title, :string
      field :description, :string
      field :start_date, :date
      field :end_date, :date
    end

    belongs_to :applicant, User

    timestamps(type: :utc_datetime)
  end

  @requried_fields ~w[title summary employment_types work_schedules field_of_art]a
  @optional_fields ~w[published]a

  @doc false
  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(cv, attrs) do
    cv
    |> cast(attrs, @requried_fields ++ @optional_fields)
    |> cast_embed(:educations, with: &education_changeset/2, requried: true)
    |> cast_embed(:jobs, with: &job_changeset/2, requried: true)
    |> validate_length(:title, max: 255)
    |> validate_length(:summary, max: 2000)
    |> validate_length(:employment_types, min: 1)
    |> validate_length(:work_schedules, min: 1)
    |> validate_educations_provided()
    |> validate_required(@requried_fields)
    |> put_change(:reviewed, true)
  end

  defp validate_educations_provided(changeset) do
    case get_embed(changeset, :educations) do
      [] -> add_error(changeset, :educations, "should be at least %{count} character(s)", count: 1)
      _educations -> changeset
    end
  end

  @education_required_fields ~w[level educational_institution specialization year_of_graduation]a
  @education_optional_fields [:department]

  @spec education_changeset(education(), map()) :: Ecto.Changeset.t()
  def education_changeset(education, attrs) do
    education
    |> cast(attrs, @education_optional_fields ++ @education_required_fields)
    |> validate_required(@education_required_fields)
  end

  @job_required_fields ~w[start_date end_date]a
  @job_optional_fields ~w[organization_name job_title description]a

  @spec job_changeset(job(), map()) :: Ecto.Changeset.t()
  def job_changeset(job, attrs) do
    job
    |> cast(attrs, @job_optional_fields ++ @job_required_fields)
    |> validate_required(@job_required_fields)
  end
end
