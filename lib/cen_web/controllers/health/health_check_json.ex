defmodule CenWeb.HealthCheckJSON do
  @moduledoc false

  @doc """
  Renders status ok.
  """
  def ok(_params) do
    %{status: "ok"}
  end
end
