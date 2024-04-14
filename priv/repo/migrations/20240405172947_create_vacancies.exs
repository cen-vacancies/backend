defmodule Cen.Repo.Migrations.CreateVacancies do
  use Ecto.Migration

  def change do
    create table(:vacancies) do
      add :published, :boolean, default: false, null: false
      add :reviewed, :boolean, default: false, null: false

      add :title, :string, null: false
      add :description, :text, null: false
      add :employment_type, :string, null: false
      add :work_schedule, :string, null: false
      add :education, :string, null: false
      add :field_of_art, :string, null: false

      add :min_years_of_work_experience, :integer, default: 0, null: false
      add :proposed_salary, :integer, default: 0, null: false
      add :organization_id, references(:organizations, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:vacancies, [:organization_id])
  end
end
