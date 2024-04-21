defmodule CenWeb.Schemas.UpdateCVRequest do
  @moduledoc false
  use CenWeb.StrictAPISchema

  alias CenWeb.Schemas.CV

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      cv: %{
        type: :object,
        optional: :all,
        properties: using_properties(CV.schema(), remove: ~w[id applicant]a)
      }
    },
    example: %{
      "cv" => using_example(CV.schema(), remove: ~w[id applicant])
    }
  })
end
