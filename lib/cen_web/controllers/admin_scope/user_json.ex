# credo:disable-for-this-file Credo.Check.Readability.Specs
defmodule CenWeb.AdminScope.UserJSON do
  @moduledoc false

  alias CenWeb.PageJSON
  alias CenWeb.UserJSON

  @doc """
  Renders a list of users.
  """
  def index(%{page: %{entries: users} = page}) do
    %{data: for(user <- users, do: UserJSON.data(user)), page: PageJSON.show(page)}
  end
end
