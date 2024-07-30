defmodule CenWeb.AdminScope.VacancyJSON do
  @moduledoc false

  alias CenWeb.PageJSON
  alias CenWeb.VacancyJSON

  @doc """
  Renders a list of vacancies.
  """
  @spec index(map()) :: map()
  def index(%{page: %{entries: vacancies} = page}) do
    %{data: for(vacancy <- vacancies, do: data(vacancy)), page: PageJSON.show(page)}
  end

  defp data(vacancy), do: VacancyJSON.data(vacancy)
end
