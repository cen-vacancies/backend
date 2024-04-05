defmodule CenWeb.VacancyJSON do
  alias CenWeb.OrganizationJSON
  alias Cen.Employers.Vacancy

  @doc """
  Renders a list of vacancies.
  """
  def index(%{vacancies: vacancies}) do
    %{data: for(vacancy <- vacancies, do: data(vacancy))}
  end

  @doc """
  Renders a single vacancy.
  """
  def show(%{vacancy: vacancy}) do
    %{data: data(vacancy)}
  end

  def data(%Vacancy{} = vacancy) do
    %{
      id: vacancy.id,
      published: vacancy.published,
      reviewed: vacancy.reviewed,
      description: vacancy.description,
      employment_type: vacancy.employment_type,
      work_schedule: vacancy.work_schedule,
      education: vacancy.education,
      field_of_art: vacancy.field_of_art,
      min_years_of_work_experience: vacancy.min_years_of_work_experience,
      proposed_salary: vacancy.proposed_salary,
      organization: OrganizationJSON.data(vacancy.organization)
    }
  end
end
