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
          years_of_work_experience: integer() | nil,
          applicant_id: integer() | nil,
          applicant: User.t() | Ecto.Association.NotLoaded.t(),
          educations: [education]
        }

  @type education :: %__MODULE__.Education{
          level: atom(),
          educational_institution: String.t(),
          department: String.t(),
          specialization: String.t(),
          year_of_graduation: integer()
        }

  schema "applicants_cvs" do
    field :title, :string
    field :summary, :string
    field :published, :boolean, default: false
    field :reviewed, :boolean, default: false
    field :employment_types, {:array, Ecto.Enum}, values: Cen.Enums.employment_types()
    field :work_schedules, {:array, Ecto.Enum}, values: Cen.Enums.work_schedules()
    field :field_of_art, Ecto.Enum, values: Cen.Enums.field_of_arts()
    field :years_of_work_experience, :integer, default: 0

    embeds_many :educations, Education, on_replace: :delete do
      field :level, Ecto.Enum, values: Cen.Enums.educations()
      field :educational_institution, :string, default: nil
      field :department, :string, default: nil
      field :specialization, :string, default: nil
      field :year_of_graduation, :integer, default: nil
    end

    belongs_to :applicant, User

    timestamps(type: :utc_datetime)
  end

  @requried_fields ~w[title summary employment_types work_schedules field_of_art]a
  @optional_fields ~w[published years_of_work_experience]a

  @doc false
  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(cv, attrs) do
    cv
    |> cast(attrs, @requried_fields ++ @optional_fields)
    |> cast_embed(:educations, with: &education_changeset/2, requried: true)
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

  @spec education_changeset(education(), map()) :: Ecto.Changeset.t()
  def education_changeset(education, attrs) do
    education
    |> cast(attrs, ~w[level educational_institution department specialization year_of_graduation]a)
    |> validate_required([:level])
  end
end
