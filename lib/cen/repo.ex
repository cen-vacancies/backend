defmodule Cen.Repo do
  use Ecto.Repo,
    otp_app: :cen,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 50, max_page_size: 100

  @spec fetch(Ecto.Queryable.t(), term(), Keyword.t()) :: Ecto.Schema.t() | term() | nil
  def fetch(queryable, id, options \\ []) do
    case get(queryable, id, options) do
      nil -> {:error, :not_found}
      item -> {:ok, item}
    end
  end
end
