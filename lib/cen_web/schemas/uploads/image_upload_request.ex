defmodule CenWeb.Schemas.ImageUploadRequest do
  @moduledoc false

  use CenWeb.StrictAPISchema

  CenWeb.StrictAPISchema.schema(%{
    type: :object,
    properties: %{
      image: %{
        type: :string,
        format: :binary
      }
    },
    example: %{
      "image" => "image-data"
    }
  })
end
