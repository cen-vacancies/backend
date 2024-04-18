defmodule Cen.ChangesetUtils do
  @moduledoc """
  A few useful changeset validators.
  """

  alias Ecto.Changeset

  @doc """
  Validates a change is a string with given prefix.
  """
  @spec validate_starts_with(Changeset.t(), atom(), String.t()) :: Changeset.t()
  def validate_starts_with(changeset, field, prefix) do
    Changeset.validate_change(changeset, field, fn _field, value ->
      if String.starts_with?(value, prefix) do
        []
      else
        [{field, ~s(should starts with a prefix "#{prefix}")}]
      end
    end)
  end
end
