defmodule Cen.Repo.Migrations.CreateApplicantsCVs do
  use Ecto.Migration

  def change do
    create table(:applicants_cvs) do
      add :title, :string, null: false
      add :published, :boolean, default: false, null: false
      add :reviewed, :boolean, default: false, null: false
      add :summary, :text, null: false
      add :employment_types, {:array, :string}, null: false
      add :work_schedules, {:array, :string}, null: false
      add :field_of_art, :string, null: false
      add :applicant_id, references(:users, on_delete: :delete_all), null: false
      add :educations, {:array, :map}, null: false, default: []
      add :jobs, {:array, :map}, null: false, default: []

      add :photo, :string, null: false

      add :searchable, :tsvector,
        null: false,
        generated: """
        ALWAYS AS (
          to_tsvector('russian', coalesce(title, '') || ' ' || coalesce(summary, ''))
        ) STORED
        """

      timestamps(type: :utc_datetime)
    end

    create index(:applicants_cvs, [:applicant_id])
    create index(:applicants_cvs, [:searchable], using: "gin")
  end
end
