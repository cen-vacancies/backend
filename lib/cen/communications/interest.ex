defmodule Cen.Communications.Interest do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias Cen.Applicants.CV
  alias Cen.Employers.Vacancy
  alias Cen.Enums

  @type t :: %__MODULE__{
          id: integer() | nil,
          from: atom() | nil,
          cv: CV.t() | Ecto.Association.NotLoaded.t(),
          cv_id: integer() | nil,
          vacancy: Vacancy.t() | Ecto.Association.NotLoaded.t(),
          vacancy_id: integer() | nil
        }

  schema "interests" do
    field :from, Ecto.Enum, values: Enums.interest_directions()

    belongs_to :cv, CV
    belongs_to :vacancy, Vacancy

    timestamps(type: :utc_datetime)
  end

  @doc false
  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(interest, attrs) do
    interest
    |> cast(attrs, [])
    |> unique_constraint([:cv_id, :vacancy_id, :from])
  end
end
