defmodule Cen.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string, null: false
      add :logo, :string
      add :description, :text, null: false
      add :address, :string, null: false
      add :contacts, :string, null: false
      add :employer_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:organizations, [:employer_id])
  end
end
