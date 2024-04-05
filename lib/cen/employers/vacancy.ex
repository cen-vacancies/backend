defmodule Cen.Employers.Vacancy do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias Cen.Employers.Organization

  @employment_types ~w[main secondary practice internship]a
  def employment_types, do: @employment_types
  @work_schedules ~w[full_time part_time remote_working hybrid_working flexible_schedule]a
  def work_schedules, do: @work_schedules
  @educations ~w[none higher secondary secondary_vocational]a
  def educations, do: @educations
  @field_of_arts ~w[music visual performing choreography folklore other]a
  def field_of_arts, do: @field_of_arts

  schema "vacancies" do
    field :published, :boolean, default: false
    field :reviewed, :boolean, default: false

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

  @requried_fields ~w[description employment_type work_schedule education field_of_art]a
  @optional_fields ~w[min_years_of_work_experience proposed_salary]a

  @doc false
  def changeset(vacancy, attrs) do
    vacancy
    |> cast(attrs, @requried_fields ++ @optional_fields)
    |> validate_required(@requried_fields)
  end
end
