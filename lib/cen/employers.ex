defmodule Cen.Employers do
  @moduledoc """
  The Employers context.
  """

  import Ecto.Query, warn: false

  alias Cen.Accounts.User
  alias Cen.Employers.Organization
  alias Cen.Employers.Vacancy
  alias Cen.QueryUtils
  alias Cen.Repo

  @doc """
  Returns the list of organizations.

  ## Examples

      iex> list_organizations()
      [%Organization{}, ...]

  """
  @spec list_organizations(map()) :: Scrivener.Page.t()
  def list_organizations(params \\ %{}) do
    Organization
    |> preload(:employer)
    |> Repo.paginate(page: params["page"], page_size: params["page_size"])
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

  @doc """
  Gets a single organization.

  Returns `{:error, :not_found}` if the Organization does not exist.

  ## Examples

      iex> fetch_organization(123)
      {:ok, %Organization{}}

      iex> fetch_organization(456)
      {:error, :not_found}

  """
  @spec fetch_organization(String.t() | integer()) :: {:ok, Organization.t()} | {:error, :not_found}
  def fetch_organization(id) do
    with {:ok, organization} <- Repo.fetch(Organization, id) do
      {:ok, Repo.preload(organization, :employer)}
    end
  end

  @spec fetch_organization_by_user(User.t()) :: {:ok, Organization.t()} | {:error, :not_found}
  def fetch_organization_by_user(user) do
    query =
      from organization in Organization,
        where: organization.employer_id == ^user.id,
        preload: :employer

    case Repo.one(query) do
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
  def create_organization(attrs) do
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

  @doc """
  Returns `true` when User is owner of given Organization.
  """
  @spec can_user_edit_organization?(Organization.t(), User.t()) :: boolean()
  def can_user_edit_organization?(%Organization{} = organization, %User{} = user) do
    organization.employer_id == user.id or user.role == :admin
  end

  @doc """
  Returns `true` when User is owner of given Vacancy.
  """
  @spec can_user_edit_vacancy?(Vacancy.t(), User.t()) :: boolean()
  def can_user_edit_vacancy?(%Vacancy{organization: organization}, %User{} = user) do
    can_user_edit_organization?(organization, user)
  end

  @doc """
  Returns the list of vacancies.

  ## Examples

      iex> list_vacancies()
      [%Vacancy{}, ...]

  """
  @spec list_vacancies() :: [Vacancy.t()]
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
  @spec get_vacancy!(String.t() | integer()) :: Vacancy.t()
  def get_vacancy!(id), do: Repo.get!(Vacancy, id)

  @doc """
  Gets a single vacancy.

  Returns `{:error, :not_found}` if the Vacancy does not exist.

  ## Examples

      iex> fetch_vacancy(123)
      {:ok, %Vacancy{}}

      iex> fetch_vacancy(456)
      {:error, :not_found}

  """
  @spec fetch_vacancy(String.t() | integer()) :: {:ok, Vacancy.t()} | {:error, :not_found}
  def fetch_vacancy(id) do
    with {:ok, vacancy} <- Repo.fetch(Vacancy, id) do
      {:ok, Repo.preload(vacancy, organization: [:employer])}
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
  @spec create_vacancy(map(), keyword()) :: {:ok, Vacancy.t()} | {:error, Ecto.Changeset.t()}
  def create_vacancy(attrs, opts \\ []) do
    attrs
    |> Map.fetch!(:organization)
    |> Ecto.build_assoc(:vacancies)
    |> Vacancy.changeset(Map.delete(attrs, :organization), opts)
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
  @spec update_vacancy(Vacancy.t(), map(), keyword()) :: {:ok, Vacancy.t()} | {:error, Ecto.Changeset.t()}
  def update_vacancy(%Vacancy{} = vacancy, attrs, opts \\ []) do
    vacancy
    |> Vacancy.changeset(attrs, opts)
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
  @spec delete_vacancy(Vacancy.t()) :: {:ok, Vacancy.t()} | {:error, Ecto.Changeset.t()}
  def delete_vacancy(%Vacancy{} = vacancy) do
    Repo.delete(vacancy)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vacancy changes.

  ## Examples

      iex> change_vacancy(vacancy)
      %Ecto.Changeset{data: %Vacancy{}}

  """
  @spec change_vacancy(Vacancy.t(), map()) :: Ecto.Changeset.t()
  def change_vacancy(%Vacancy{} = vacancy, attrs \\ %{}) do
    Vacancy.changeset(vacancy, attrs)
  end

  @spec get_vacancies_by_organization_id(integer(), map()) :: Scrivener.Page.t()
  def get_vacancies_by_organization_id(organization_id, options) do
    from(vacancy in Vacancy)
    |> where([vacancy], vacancy.organization_id == ^organization_id)
    |> preload(organization: [:employer])
    |> Repo.paginate(page: options["page"], page_size: options["page_size"])
  end

  @spec search_vacancies(map()) :: Scrivener.Page.t()
  def search_vacancies(options) do
    Vacancy
    |> where([vacancy], vacancy.published)
    |> where([vacancy], vacancy.reviewed)
    |> QueryUtils.filter(:searchable, :search, options["text"])
    |> QueryUtils.filter(:employment_types, :intersection, options["employment_types"])
    |> QueryUtils.filter(:work_schedules, :intersection, options["work_schedules"])
    |> QueryUtils.filter(:field_of_art, :eq, options["field_of_art"])
    |> QueryUtils.filter(:min_years_of_work_experience, :not_gt, options["years_of_work_experience"])
    |> QueryUtils.filter(:proposed_salary, :not_lt, options["preferred_salary"])
    |> filter_education(options["education"])
    |> preload(organization: [:employer])
    |> Repo.paginate(page: options["page"], page_size: options["page_size"])
  end

  @reversed_educations Cen.Enums.educations() |> Enum.map(&to_string/1) |> Enum.reverse()

  defp filter_education(query, nil), do: query

  defp filter_education(query, education) do
    educations = Enum.drop_while(@reversed_educations, &(&1 != education))

    QueryUtils.filter(query, :education, :field_in_value, educations)
  end

  @spec list_unreviewed_vacancies(map()) :: Scrivener.Page.t()
  def list_unreviewed_vacancies(params) do
    Vacancy
    |> where([vacancy], not vacancy.reviewed)
    |> preload(organization: [:employer])
    |> Repo.paginate(page: params["page"], page_size: params["page_size"])
  end
end
