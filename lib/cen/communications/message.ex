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

  def set_author_id(%__MODULE__{author_id: nil} = message, author_id) do
    %{message | author_id: author_id}
  end

  @doc false
  @spec changeset(__MODULE__.t(), map()) :: Ecto.Changeset.t()
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:text])
    |> validate_required([:text])
    |> unsafe_check_user_in_chat()
  end

  defp unsafe_check_user_in_chat(changeset) do
    chat_id = get_field(changeset, :chat_id)
    author_id = get_field(changeset, :author_id)

    if is_nil(author_id) do
      add_error(changeset, :author_id, "can't be blank")
    else
      %{entries: entries} = Cen.Communications.get_chats_by_user(author_id)

      case Enum.find(entries, fn %{id: id} -> id == chat_id end) do
        nil ->
          add_error(changeset, :author_id, "is not in the chat")

        _chats ->
          changeset
      end
    end
  end
end
