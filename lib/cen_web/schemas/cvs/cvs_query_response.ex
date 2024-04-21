defmodule CenWeb.Schemas.Vacancies.CVsQueryResponse do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.CV
  alias CenWeb.Schemas.Page

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      data: %{
        type: :array,
        items: CV.schema()
      },
      page: Page.schema()
    },
    example: %{
      "data" => [CV.schema().example],
      "page" => Page.schema().example
    }
  })
end
