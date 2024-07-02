defmodule CenWeb.Schemas.Phone do
  @moduledoc false

  use CenWeb.StrictAPISchema

  @phone_description """
  Phone number

  - Must contain 12 characters
  - Must begin with "+7"
  """

  CenWeb.StrictAPISchema.schema(%{
    title: "",
    type: :string,
    example: "+79001234567",
    description: @phone_description,
    maxLength: 12
  })
end
