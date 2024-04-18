defmodule Cen.Repo.Migrations.AddPhoneToUsers do
  use Ecto.Migration

  def up do
    alter table(:users) do
      add :phone, :string, null: false, default: ""
    end

    execute "ALTER TABLE users ALTER COLUMN phone DROP DEFAULT;"
  end

  def down do
    execute "ALTER TABLE users DROP COLUMN phone"
  end
end
