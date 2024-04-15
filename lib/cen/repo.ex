defmodule Cen.Repo do
  use Ecto.Repo,
    otp_app: :cen,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10, max_page_size: 50
end
