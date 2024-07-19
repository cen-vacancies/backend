# credo:disable-for-this-file Credo.Check.Readability.Specs
defmodule Cen.ApplicantsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cen.Applicants` context.
  """
  alias Cen.AccountsFixtures

  @doc """
  Generate a cv.
  """
  def cv_fixture(attrs \\ %{}) do
    {:ok, cv} =
      attrs
      |> Enum.into(%{
        applicant: AccountsFixtures.user_fixture(),
        employment_types: [:main, :secondary],
        field_of_art: :folklore,
        published: true,
        reviewed: true,
        summary: "some summary",
        title: "some title",
        work_schedules: [:full_time, :part_time],
        educations: [
          %{
            level: :secondary,
            educational_institution: "УрФУ",
            department: "Архитектурный факультет",
            specialization: "Архитектура зданий и сооружений. Творческие концепции архитектурной деятельности",
            year_of_graduation: 2024
          }
        ],
        jobs: [
          %{
            organization_name: "УрФУ",
            job_title: "Преподаватель",
            description: "Преподавал предмет",
            start_date: ~D[2022-12-01],
            end_date: ~D[2024-02-01]
          }
        ]
      })
      |> Cen.Applicants.create_cv(admin: true)

    cv
  end
end
