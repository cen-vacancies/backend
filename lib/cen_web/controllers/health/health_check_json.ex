defmodule CenWeb.HealthCheckJSON do
  @moduledoc false

  @doc """
  Renders status ok.
  """
  @spec ok(any()) :: %{status: String.t()}
  def ok(_params) do
    %{status: "ok"}
  end
end
