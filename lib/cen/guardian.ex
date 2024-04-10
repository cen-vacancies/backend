defmodule Cen.Token do
  @moduledoc false
  use Guardian, otp_app: :cen

  @impl Guardian
  def subject_for_token(%{id: id}, _claims) do
    {:ok, to_string(id)}
  end

  @impl Guardian
  def resource_from_claims(%{"sub" => id}) do
    Cen.Accounts.fetch_user(id)
  end
end
