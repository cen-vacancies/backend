# credo:disable-for-this-file Credo.Check.Readability.Specs
defmodule CenWeb.CVJSON do
  @moduledoc false

  alias Cen.Applicants.CV
  alias CenWeb.PageJSON

  @doc """
  Renders a list of cvs.
  """
  def index(%{page: %{entries: cvs} = page}) do
    %{data: for(cv <- cvs, do: data(cv)), page: PageJSON.show(page)}
  end

  @doc """
  Renders a single cv.
  """
  def show(%{cv: cv}) do
    %{data: data(cv)}
  end

  defp data(%CV{} = cv) do
    %{
      id: cv.id,
      published: cv.published,
      reviewed: cv.reviewed,
      title: cv.title,
      summary: cv.summary,
      employment_types: cv.employment_types,
      work_schedules: cv.work_schedules,
      field_of_art: cv.field_of_art,
      years_of_work_experience: cv.years_of_work_experience,
      applicant: CenWeb.UserJSON.data(cv.applicant),
      educations: Enum.map(cv.educations, &data_educations/1)
    }
  end

  def data_educations(education) do
    %{
      level: education.level,
      educational_institution: education.educational_institution,
      department: education.department,
      specialization: education.specialization,
      year_of_graduation: education.year_of_graduation
    }
  end
end
