defmodule Cen.Repo.Migrations.CreateInterests do
  use Ecto.Migration

  def change do
    create table(:interests) do
      add :from, :string, null: false
      add :cv_id, references(:applicants_cvs, on_delete: :delete_all), null: false
      add :vacancy_id, references(:vacancies, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:interests, [:cv_id])
    create index(:interests, [:vacancy_id])
    create unique_index(:interests, [:cv_id, :vacancy_id, :from])
  end
end
