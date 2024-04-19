defmodule Cen.Repo.Migrations.ChangeVacanciesFieldsToLists do
  use Ecto.Migration

  def change do
    alter table(:vacancies) do
      add :employment_types, {:array, :string}, default: [], null: false
      add :work_schedules, {:array, :string}, default: [], null: false
      add :educations, {:array, :string}, default: [], null: false

      remove :employment_type
      remove :work_schedule
      remove :education
    end
  end
end
