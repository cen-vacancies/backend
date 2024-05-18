defmodule Cen.Communications.Message do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias Cen.Communications.Chat

  @type t :: %__MODULE__{
          type: atom() | nil,
          text: String.t() | nil,
          author_id: integer() | nil,
          chat_id: integer() | nil,
          chat: Chat.t() | nil
        }

  schema "messages" do
    field :type, Ecto.Enum, values: Cen.Enums.message_types()
    field :text, :string
    field :author_id, :id

    belongs_to :chat, Chat

    timestamps(type: :utc_datetime)
  end

  @doc false
  @spec changeset(__MODULE__.t(), map()) :: Ecto.Changeset.t()
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:text, :type, :author_id])
    |> validate_required([:type, :author_id])
    |> validate_text()
    |> unique_constraint(:type, name: "messages_chat_id_type_index", message: "already sent")
  end

  defp validate_text(changeset) do
    case get_field(changeset, :type) do
      :default -> validate_required(changeset, [:text])
      _otherwise -> validate_text_is_nil(changeset)
    end
  end

  defp validate_text_is_nil(changeset) do
    case get_field(changeset, :text) do
      nil -> changeset
      _otherwise -> add_error(changeset, :text, "text is only allowed for default messages")
    end
  end
end
