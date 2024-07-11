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
    |> unsafe_check_user_in_chat()
  end

  def unsafe_check_user_in_chat(changeset) do
    chat_id = get_field(changeset, :chat_id)
    author_id = get_field(changeset, :author_id)

    %{entries: entries} = Cen.Communications.get_chats_by_user(author_id)

    case Enum.find(entries, fn %{id: id} -> id == chat_id end) do
      nil ->
        add_error(changeset, :author_id, "is not in the chat")

      _ ->
        changeset
    end
  end
end
