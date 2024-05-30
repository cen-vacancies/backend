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

  def data(%CV{} = cv) do
    %{
      id: cv.id,
      published: cv.published,
      reviewed: cv.reviewed,
      title: cv.title,
      summary: cv.summary,
      employment_types: cv.employment_types,
      work_schedules: cv.work_schedules,
      field_of_art: cv.field_of_art,
      photo: cv.photo,
      applicant: CenWeb.UserJSON.data(cv.applicant),
      educations: Enum.map(cv.educations, &data_education/1),
      jobs: Enum.map(cv.jobs, &data_job/1)
    }
  end

  def data_education(education) do
    %{
      level: education.level,
      educational_institution: education.educational_institution,
      department: education.department,
      specialization: education.specialization,
      year_of_graduation: education.year_of_graduation
    }
  end

  def data_job(job) do
    %{
      organization_name: job.organization_name,
      job_title: job.job_title,
      description: job.description,
      start_date: job.start_date,
      end_date: job.end_date
    }
  end
end
