defmodule CenWeb.TokenJSON do
  def show(%{token: token}) do
    %{data: %{token: token}}
  end
end
