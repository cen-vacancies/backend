defmodule Cen.Employers.Organization do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias Cen.Accounts.User

  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          address: String.t(),
          description: String.t(),
          logo: String.t(),
          contacts: String.t(),
          employer: User.t() | Ecto.Association.NotLoaded.t(),
          employer_id: integer()
        }

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
  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :logo, :description, :address, :contacts])
    |> validate_length(:name, max: 255)
    |> validate_length(:address, max: 255)
    |> validate_length(:contacts, max: 255)
    |> validate_length(:description, max: 2000)
    |> validate_required([:name, :description, :address, :contacts])
  end
end
