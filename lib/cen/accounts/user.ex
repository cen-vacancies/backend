defmodule Cen.Accounts.User do
  @moduledoc false
  use Ecto.Schema

  import Cen.ChangesetUtils
  import Ecto.Changeset

  alias Cen.Applicants.CV
  alias Cen.Employers.Organization

  @type t :: %__MODULE__{
          id: integer() | nil,
          email: String.t() | nil,
          password: String.t() | nil,
          hashed_password: String.t() | nil,
          fullname: String.t() | nil,
          role: atom() | nil,
          birth_date: Date.t() | nil,
          confirmed_at: NaiveDateTime.t() | nil,
          organization: Organization.t() | Ecto.Association.NotLoaded.t(),
          cvs: [CV.t()] | Ecto.Association.NotLoaded.t()
        }

  schema "users" do
    field :email, :string
    field :phone, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :fullname, :string
    field :role, Ecto.Enum, values: Cen.Enums.user_roles()
    field :birth_date, :date
    field :confirmed_at, :naive_datetime

    has_one :organization, Organization, foreign_key: :employer_id
    has_many :cvs, CV, foreign_key: :applicant_id

    timestamps(type: :utc_datetime)
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.

    * `:validate_email` - Validates the uniqueness of the email, in case
      you don't want to validate the uniqueness of the email (like when
      using this changeset for validations on a LiveView form before
      submitting the form), this option can be set to `false`.
      Defaults to `true`.
  """
  @spec registration_changeset(t(), map(), keyword()) :: Ecto.Changeset.t()
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, ~w[email password fullname role birth_date phone]a)
    |> validate_email(opts)
    |> validate_password(opts)
    |> validate_phone()
    |> validate_length(:fullname, max: 160)
    |> validate_required(~w[fullname birth_date]a)
    |> validate_role(opts)
  end

  defp validate_role(changeset, opts) do
    changeset = validate_required(changeset, [:role])

    if Keyword.get(opts, :allow_admin, false) do
      changeset
    else
      validate_exclusion(changeset, :role, ~w[admin]a)
    end
  end

  defp validate_email(changeset, opts) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> maybe_validate_unique_email(opts)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 72)
    # Examples of additional password validation:
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      # Hashing could be done with `Ecto.Changeset.prepare_changes/2`, but that
      # would keep the database transaction open longer and hurt performance.
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  defp maybe_validate_unique_email(changeset, opts) do
    if Keyword.get(opts, :validate_email, true) do
      changeset
      |> unsafe_validate_unique(:email, Cen.Repo)
      |> unique_constraint(:email)
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  @spec email_changeset(t(), map(), keyword()) :: Ecto.Changeset.t()
  def email_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email])
    |> validate_email(opts)
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A user changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  @spec password_changeset(t(), map(), keyword()) :: Ecto.Changeset.t()
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  @spec confirm_changeset(t() | Ecto.Changeset.t()) :: Ecto.Changeset.t()
  def confirm_changeset(user) do
    now = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  @spec valid_password?(t(), String.t()) :: boolean()
  def valid_password?(%Cen.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(__user, _password) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  @spec validate_current_password(Ecto.Changeset.t(), String.t()) :: Ecto.Changeset.t()
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end

  @doc """
  A user changeset for updating info about user.
  """
  @spec info_changeset(t(), map()) :: Ecto.Changeset.t()
  def info_changeset(user, attrs) do
    user
    |> cast(attrs, ~w[fullname birth_date phone]a)
    |> validate_required(~w[fullname]a)
    |> validate_phone()
  end

  defp validate_phone(changeset) do
    changeset
    |> validate_required([:phone])
    |> validate_length(:phone, is: 12)
    |> validate_starts_with(:phone, "+7")
  end
end
