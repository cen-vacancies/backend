defmodule Cen.Employers do
  @moduledoc """
  The Employers context.
  """

  import Ecto.Query, warn: false

  alias Cen.Employers.Organization
  alias Cen.Repo

  @doc """
  Returns the list of organizations.

  ## Examples

      iex> list_organizations()
      [%Organization{}, ...]

  """
  @spec list_organizations() :: [Organization.t()]
  def list_organizations do
    Repo.all(Organization)
  end

  @doc """
  Gets a single organization.

  Raises `Ecto.NoResultsError` if the Organization does not exist.

  ## Examples

      iex> get_organization!(123)
      %Organization{}

      iex> get_organization!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_organization!(String.t() | integer()) :: Organization.t()
  def get_organization!(id), do: Repo.get!(Organization, id)

  @spec fetch_organization(String.t() | integer()) :: {:ok, Organization.t()} | {:error, :not_found}
  def fetch_organization(id) do
    case Organization |> Repo.get(id) |> Repo.preload(:employer) do
      nil -> {:error, :not_found}
      organization -> {:ok, organization}
    end
  end

  @doc """
  Creates a organization.

  ## Examples

      iex> create_organization(%{field: value})
      {:ok, %Organization{}}

      iex> create_organization(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_organization(map()) :: {:ok, Organization.t()} | {:error, Ecto.Changeset.t()}
  def create_organization(attrs \\ %{}) do
    attrs
    |> Map.fetch!(:employer)
    |> Ecto.build_assoc(:organization)
    |> Organization.changeset(Map.delete(attrs, :employer))
    |> Repo.insert()
  end

  @doc """
  Updates a organization.

  ## Examples

      iex> update_organization(organization, %{field: new_value})
      {:ok, %Organization{}}

      iex> update_organization(organization, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_organization(Organization.t(), map()) :: {:ok, Organization.t()} | {:error, Ecto.Changeset.t()}
  def update_organization(%Organization{} = organization, attrs) do
    organization
    |> Organization.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a organization.

  ## Examples

      iex> delete_organization(organization)
      {:ok, %Organization{}}

      iex> delete_organization(organization)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_organization(Organization.t()) :: {:ok, Organization.t()} | {:error, Ecto.Changeset.t()}
  def delete_organization(%Organization{} = organization) do
    Repo.delete(organization)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking organization changes.

  ## Examples

      iex> change_organization(organization)
      %Ecto.Changeset{data: %Organization{}}

  """
  @spec change_organization(Organization.t(), map()) :: Ecto.Changeset.t()
  def change_organization(%Organization{} = organization, attrs \\ %{}) do
    Organization.changeset(organization, attrs)
  end
end
