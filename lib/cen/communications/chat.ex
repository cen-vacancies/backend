defmodule Cen.Communications.Chat do
  @moduledoc false
  use Ecto.Schema

  alias Cen.Applicants.CV
  alias Cen.Employers.Vacancy

  @type t :: %__MODULE__{
          id: integer() | nil,
          vacancy_id: integer() | nil,
          cv_id: integer() | nil,
          vacancy: Vacancy.t() | nil,
          cv: CV.t() | nil
        }

  schema "chats" do
    belongs_to :vacancy, Vacancy
    belongs_to :cv, CV

    timestamps(type: :utc_datetime)
  end
end
