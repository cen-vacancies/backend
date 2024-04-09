defmodule CenWeb.TokenJSON do
  @spec show(map()) :: map()
  def show(%{token: token}) do
    %{data: %{token: token}}
  end
end
