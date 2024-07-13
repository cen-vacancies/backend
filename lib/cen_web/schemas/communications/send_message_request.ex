defmodule CenWeb.Schemas.SendMessageRequest do
  @moduledoc false
  use CenWeb.StrictAPISchema

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      cv_id: %{type: :integer},
      vacancy_id: %{type: :integer},
      text: %{type: :string}
    },
    example: %{
      "cv_id" => 1,
      "vacancy_id" => 1,
      "text" => "I am interested in this vacancy"
    }
  })
end
