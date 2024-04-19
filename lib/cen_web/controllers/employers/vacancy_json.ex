defmodule CenWeb.VacancyJSON do
  alias Cen.Employers.Vacancy
  alias CenWeb.OrganizationJSON
  alias CenWeb.PageJSON

  @doc """
  Renders a list of vacancies.
  """
  @spec index(map()) :: map()
  def index(%{page: %{entries: vacancies} = page}) do
    %{data: for(vacancy <- vacancies, do: data(vacancy)), page: PageJSON.show(page)}
  end

  @doc """
  Renders a single vacancy.
  """
  @spec show(map()) :: map()
  def show(%{vacancy: vacancy}) do
    %{data: data(vacancy)}
  end

  @spec data(Vacancy.t()) :: map()
  def data(%Vacancy{} = vacancy) do
    %{
      id: vacancy.id,
      reviewed: vacancy.reviewed,
      published: vacancy.published,
      title: vacancy.title,
      description: vacancy.description,
      employment_types: vacancy.employment_types,
      work_schedules: vacancy.work_schedules,
      educations: vacancy.educations,
      field_of_art: vacancy.field_of_art,
      proposed_salary: vacancy.proposed_salary,
      min_years_of_work_experience: vacancy.min_years_of_work_experience,
      organization: OrganizationJSON.data(vacancy.organization)
    }
  end
end
