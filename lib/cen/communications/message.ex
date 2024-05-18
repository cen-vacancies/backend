defmodule Cen.Communications.Message do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias Cen.Communications.Chat

  @type t :: %__MODULE__{
          text: String.t() | nil,
          author_id: integer() | nil,
          chat_id: integer() | nil,
          chat: Chat.t() | nil
        }

  schema "messages" do
    field :text, :string
    field :author_id, :id

    belongs_to :chat, Chat

    timestamps(type: :utc_datetime)
  end

  @doc false
  @spec changeset(__MODULE__.t(), map()) :: Ecto.Changeset.t()
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:text, :author_id])
    |> validate_required([:text, :author_id])
  end
end
