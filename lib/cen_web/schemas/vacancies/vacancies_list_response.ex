defmodule CenWeb.Schemas.VacanciesListResponse do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.Utils
  alias CenWeb.Schemas.Vacancy

  Vacancy
  |> Utils.list_of()
  |> CenWeb.StrictAPISchema.schema()
end
