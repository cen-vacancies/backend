defmodule Cen.Employers.Vacancy do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias Cen.Employers.Organization

  @type t :: %__MODULE__{
          published: boolean(),
          reviewed: boolean(),
          title: String.t(),
          description: String.t(),
          employment_types: [atom()],
          work_schedules: [atom()],
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

    field :employment_types, {:array, Ecto.Enum}, values: Cen.Enums.employment_types()
    field :work_schedules, {:array, Ecto.Enum}, values: Cen.Enums.work_schedules()

    field :education, Ecto.Enum, values: Cen.Enums.educations()
    field :field_of_art, Ecto.Enum, values: Cen.Enums.field_of_arts()

    field :min_years_of_work_experience, :integer, default: 0
    field :proposed_salary, :integer

    belongs_to :organization, Organization

    timestamps(type: :utc_datetime)
  end

  @requried_fields ~w[title field_of_art description employment_types work_schedules education]a
  @optional_fields ~w[reviewed published min_years_of_work_experience proposed_salary]a

  @doc false
  @spec changeset(t(), map(), keyword()) :: Ecto.Changeset.t()
  def changeset(vacancy, attrs, opts \\ []) do
    vacancy
    |> cast(attrs, @requried_fields ++ @optional_fields)
    |> validate_length(:title, max: 160)
    |> validate_length(:description, max: 2000)
    |> validate_length(:employment_types, min: 1)
    |> validate_length(:work_schedules, min: 1)
    |> validate_required(@requried_fields)
    |> validate_reviewed(opts)
  end

  defp validate_reviewed(changeset, opts) do
    admin? = Keyword.get(opts, :admin, false)

    if admin? do
      changeset
    else
      delete_change(changeset, :reviewed)
    end
  end
end
