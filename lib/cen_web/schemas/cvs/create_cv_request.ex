defmodule CenWeb.Schemas.CreateCVRequest do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.CV

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      cv: %{
        type: :object,
        optional: ~w[published]a,
        properties: using_properties(CV.schema(), remove: ~w[id applicant]a)
      }
    },
    example: %{
      "cv" => using_example(CV.schema(), remove: ~w[id applicant])
    }
  })
end
