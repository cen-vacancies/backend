defmodule Cen.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :text, :string
      add :type, :string, null: false
      add :chat_id, references(:chats, on_delete: :delete_all)
      add :author_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:messages, [:chat_id])
    create unique_index(:messages, [:chat_id, :type], where: "type IN ('interest', 'waiver')")
    create index(:messages, [:author_id])
  end
end
