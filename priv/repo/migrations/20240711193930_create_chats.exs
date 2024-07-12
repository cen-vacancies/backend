defmodule Cen.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add :vacancy_id, references(:vacancies, on_delete: :delete_all)
      add :cv_id, references(:applicants_cvs, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:chats, [:vacancy_id])
    create index(:chats, [:cv_id])
    create unique_index(:chats, [:vacancy_id, :cv_id])
  end
end
