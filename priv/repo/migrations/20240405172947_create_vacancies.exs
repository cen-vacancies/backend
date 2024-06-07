defmodule Cen.Repo.Migrations.CreateVacancies do
  use Ecto.Migration

  def change do
    create table(:vacancies) do
      add :published, :boolean, default: false, null: false
      add :reviewed, :boolean, default: false, null: false

      add :title, :string, null: false
      add :description, :text, null: false
      add :employment_types, {:array, :string}, default: [], null: false
      add :work_schedules, {:array, :string}, default: [], null: false

      add :education, :string, null: false
      add :field_of_art, :string, null: false

      add :min_years_of_work_experience, :integer, default: 0, null: false
      add :proposed_salary, :integer
      add :organization_id, references(:organizations, on_delete: :delete_all), null: false

      add :searchable, :tsvector,
        null: false,
        generated: """
        ALWAYS AS (
          to_tsvector('russian', coalesce(title, '') || ' ' || coalesce(description, ''))
        ) STORED
        """

      timestamps(type: :utc_datetime)
    end

    create index(:vacancies, [:organization_id])

    create index(:vacancies, [:searchable], using: "gin")
  end
end
