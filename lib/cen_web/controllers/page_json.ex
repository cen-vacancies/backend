defmodule CenWeb.PageJSON do
  @moduledoc false

  @doc false
  @spec show(map()) :: map()
  def show(%{page_number: page_number, page_size: page_size, total_entries: total_entries, total_pages: total_pages}) do
    %{
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    }
  end
end
