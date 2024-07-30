defmodule CenWeb.AdminScope.CVJSON do
  @moduledoc false

  alias CenWeb.CVJSON
  alias CenWeb.PageJSON

  @doc """
  Renders a list of cvs.
  """
  @spec index(map()) :: map()
  def index(%{page: %{entries: cvs} = page}) do
    %{data: for(cv <- cvs, do: data(cv)), page: PageJSON.show(page)}
  end

  defp data(cv), do: CVJSON.data(cv)
end
