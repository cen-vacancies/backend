defmodule Cen.Employers.Vacancy do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias Cen.Employers.Organization

  @spec employment_types() :: [atom(), ...]
  @employment_types ~w[main secondary practice internship]a
  def employment_types, do: @employment_types

  @spec work_schedules() :: [atom(), ...]
  @work_schedules ~w[full_time part_time remote_working hybrid_working flexible_schedule]a
  def work_schedules, do: @work_schedules

  @spec educations() :: [atom(), ...]
  @educations ~w[none higher secondary secondary_vocational]a
  def educations, do: @educations

  @spec field_of_arts() :: [atom(), ...]
  @field_of_arts ~w[music visual performing choreography folklore other]a
  def field_of_arts, do: @field_of_arts

  @type t :: %__MODULE__{
          published: boolean(),
          reviewed: boolean(),
          title: String.t(),
          description: String.t(),
          employment_type: atom(),
          work_schedule: atom(),
          education: atom(),
          field_of_art: atom(),
          min_years_of_work_experience: integer(),
          proposed_salary: integer(),
          organization: Organization.t() | Ecto.Association.NotLoaded.t()
        }

  schema "vacancies" do
    field :published, :boolean, default: false
    field :reviewed, :boolean, default: false

    field :title, :string
    field :description, :string

    field :employment_type, Ecto.Enum, values: @employment_types
    field :work_schedule, Ecto.Enum, values: @work_schedules
    field :education, Ecto.Enum, values: @educations
    field :field_of_art, Ecto.Enum, values: @field_of_arts

    field :min_years_of_work_experience, :integer, default: 0
    field :proposed_salary, :integer, default: 0

    belongs_to :organization, Organization

    timestamps(type: :utc_datetime)
  end

  @requried_fields ~w[title description employment_type work_schedule education field_of_art]a
  @optional_fields ~w[min_years_of_work_experience proposed_salary]a

  @doc false
  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(vacancy, attrs) do
    vacancy
    |> cast(attrs, @requried_fields ++ @optional_fields)
    |> validate_length(:title, max: 255)
    |> validate_length(:description, max: 2000)
    |> validate_required(@requried_fields)
  end
end
