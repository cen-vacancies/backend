defmodule Cen.Employers do
  @moduledoc """
  The Employers context.
  """

  import Ecto.Query, warn: false

  alias Cen.Employers.Organization
  alias Cen.Employers.Vacancy
  alias Cen.Repo

  @doc """
  Returns the list of organizations.

  ## Examples

      iex> list_organizations()
      [%Organization{}, ...]

  """
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
  def get_organization!(id), do: Repo.get!(Organization, id)

  def fetch_organization(id) do
    case Repo.get(Organization, id) do
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
  def delete_organization(%Organization{} = organization) do
    Repo.delete(organization)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking organization changes.

  ## Examples

      iex> change_organization(organization)
      %Ecto.Changeset{data: %Organization{}}

  """
  def change_organization(%Organization{} = organization, attrs \\ %{}) do
    Organization.changeset(organization, attrs)
  end

  @doc """
  Returns the list of vacancies.

  ## Examples

      iex> list_vacancies()
      [%Vacancy{}, ...]

  """
  def list_vacancies do
    Repo.all(Vacancy)
  end

  @doc """
  Gets a single vacancy.

  Raises `Ecto.NoResultsError` if the Vacancy does not exist.

  ## Examples

      iex> get_vacancy!(123)
      %Vacancy{}

      iex> get_vacancy!(456)
      ** (Ecto.NoResultsError)

  """
  def get_vacancy!(id), do: Repo.get!(Vacancy, id)

  def fetch_vacancy(id) do
    case Vacancy |> Repo.get(id) |> Repo.preload(organization: [:employer]) do
      nil -> {:error, :not_found}
      vacancy -> {:ok, vacancy}
    end
  end

  @doc """
  Creates a vacancy.

  ## Examples

      iex> create_vacancy(%{field: value})
      {:ok, %Vacancy{}}

      iex> create_vacancy(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_vacancy(attrs \\ %{}) do
    attrs
    |> Map.fetch!(:organization)
    |> Ecto.build_assoc(:vacancies)
    |> Vacancy.changeset(Map.delete(attrs, :organization))
    |> Repo.insert()
  end

  @doc """
  Updates a vacancy.

  ## Examples

      iex> update_vacancy(vacancy, %{field: new_value})
      {:ok, %Vacancy{}}

      iex> update_vacancy(vacancy, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_vacancy(%Vacancy{} = vacancy, attrs) do
    vacancy
    |> Vacancy.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a vacancy.

  ## Examples

      iex> delete_vacancy(vacancy)
      {:ok, %Vacancy{}}

      iex> delete_vacancy(vacancy)
      {:error, %Ecto.Changeset{}}

  """
  def delete_vacancy(%Vacancy{} = vacancy) do
    Repo.delete(vacancy)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vacancy changes.

  ## Examples

      iex> change_vacancy(vacancy)
      %Ecto.Changeset{data: %Vacancy{}}

  """
  def change_vacancy(%Vacancy{} = vacancy, attrs \\ %{}) do
    Vacancy.changeset(vacancy, attrs)
  end
end
