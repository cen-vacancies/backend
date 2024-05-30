# credo:disable-for-this-file Credo.Check.Readability.Specs
defmodule CenWeb.InterestJSON do
  alias Cen.Communications.Interest
  alias CenWeb.CVJSON
  alias CenWeb.PageJSON
  alias CenWeb.VacancyJSON

  def index(%{page: %{entries: entries} = page}) do
    %{data: for(entry <- entries, do: data(entry)), page: PageJSON.show(page)}
  end

  def show(%{interest: interest}) do
    %{data: data(interest)}
  end

  def data(%Interest{} = interest) do
    %{
      id: interest.id,
      from: interest.from,
      cv: CVJSON.data(interest.cv),
      vacancy: VacancyJSON.data(interest.vacancy)
    }
  end
end
