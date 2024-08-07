defmodule Cen.Employers.Organization do
  @moduledoc false
  use Ecto.Schema

  import Cen.ChangesetUtils
  import Ecto.Changeset

  alias Cen.Accounts.User
  alias Cen.Employers.Vacancy

  @type t :: %__MODULE__{
          id: integer() | nil,
          name: String.t(),
          address: String.t(),
          description: String.t(),
          logo: String.t(),
          employer: User.t() | Ecto.Association.NotLoaded.t(),
          employer_id: integer(),
          phone: String.t() | nil,
          email: String.t() | nil,
          website: String.t() | nil,
          social_link: String.t() | nil
        }

  schema "organizations" do
    field :name, :string
    field :address, :string
    field :description, :string
    field :logo, :string, default: "/images/no_photo.jpg"
    field :phone, :string

    field :email, :string
    field :website, :string
    field :social_link, :string

    belongs_to :employer, User
    has_many :vacancies, Vacancy

    timestamps(type: :utc_datetime)
  end

  @required_fields ~w[name description phone]a
  @optional_fields ~w[address logo email website social_link]a

  @doc false
  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_length(:name, max: 160)
    |> validate_length(:address, max: 160)
    |> validate_length(:email, max: 160)
    |> validate_length(:website, max: 160)
    |> validate_length(:social_link, max: 160)
    |> validate_length(:description, max: 2000)
    |> validate_phone()
    |> validate_required(@required_fields)
  end

  defp validate_phone(changeset) do
    changeset
    |> validate_length(:phone, is: 12)
    |> validate_starts_with(:phone, "+7")
  end
end
