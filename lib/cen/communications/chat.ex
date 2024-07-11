defmodule Cen.Communications.Chat do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias Cen.Applicants.CV
  alias Cen.Communications.Message
  alias Cen.Employers.Vacancy

  @type t :: %__MODULE__{
          id: integer() | nil,
          vacancy_id: integer() | nil,
          cv_id: integer() | nil,
          vacancy: Vacancy.t() | nil,
          cv: CV.t() | nil,
          messages: [Message.t()] | Ecto.Association.NotLoaded.t()
        }

  schema "chats" do
    belongs_to :vacancy, Vacancy
    belongs_to :cv, CV

    has_many :messages, Message

    timestamps(type: :utc_datetime)
  end

  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [])
    |> unique_constraint([:vacancy_id, :cv_id])
  end
end
