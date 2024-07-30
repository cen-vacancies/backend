defmodule CenWeb.Schemas.CVsListResponse do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.CV
  alias CenWeb.Schemas.Utils

  CV
  |> Utils.list_of()
  |> CenWeb.StrictAPISchema.schema()
end
