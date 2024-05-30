defmodule Cen.Communications do
  @moduledoc false

  alias Cen.Communications.Interest
  alias Cen.Repo

  @spec send_interest(atom(), integer(), integer()) :: {:ok, Interest.t()} | {:error, Ecto.Changeset.t()}
  def send_interest(user_type, cv_id, vacancy_id) do
    %Interest{cv_id: cv_id, vacancy_id: vacancy_id, from: user_type}
    |> Interest.changeset(%{})
    |> Repo.insert()
  end

  @spec get_interest!(integer()) :: Interest.t()
  def get_interest!(id) do
    Interest
    |> Repo.get!(id)
    |> Repo.preload(vacancy: [organization: [employer: []]], cv: [applicant: []])
  end
end
