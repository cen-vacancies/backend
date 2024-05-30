# credo:disable-for-this-file Credo.Check.Readability.Specs
defmodule CenWeb.InterestJSON do
  alias Cen.Communications.Interest
  alias CenWeb.CVJSON
  alias CenWeb.VacancyJSON

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
