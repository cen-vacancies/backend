defmodule Cen.Employers.Organization do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias Cen.Accounts.User

  schema "organizations" do
    field :name, :string
    field :address, :string
    field :description, :string
    field :logo, :string
    field :contacts, :string

    belongs_to :employer, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :logo, :description, :address, :contacts])
    |> validate_required([:name, :description, :address, :contacts])
  end
end
