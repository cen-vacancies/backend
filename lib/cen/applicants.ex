defmodule Cen.Applicants do
  @moduledoc """
  The Applicants context.
  """

  import Ecto.Query, warn: false

  alias Cen.Accounts.User
  alias Cen.Applicants.CV
  alias Cen.QueryUtils
  alias Cen.Repo

  @doc """
  Returns the list of cvs.

  ## Examples

      iex> list_cvs()
      [%CV{}, ...]

  """
  @spec list_cvs() :: [CV.t()]
  def list_cvs do
    Repo.all(CV)
  end

  @doc """
  Gets a single cv.

  Raises `Ecto.NoResultsError` if the CV does not exist.

  ## Examples

      iex> get_cv!(123)
      %CV{}

      iex> get_cv!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_cv!(integer() | String.t()) :: [CV.t()]
  def get_cv!(id), do: Repo.get!(CV, id)

  @doc """
  Fetchs a single CV.

  Returns `{:error, :not_found}` if the CV does not exist.

  ## Examples

      iex> fetch_cv(123)
      {:ok, %CV{}}

      iex> fetch_cv(456)
      {:error, :not_found}

  """
  @spec fetch_cv(integer() | String.t()) :: {:ok, CV.t()} | {:error, :not_found}
  def fetch_cv(id) do
    with {:ok, cv} <- Repo.fetch(CV, id) do
      {:ok, Repo.preload(cv, :applicant)}
    end
  end

  @doc """
  Creates a cv.

  ## Examples

      iex> create_cv(%{field: value})
      {:ok, %CV{}}

      iex> create_cv(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_cv(map(), keyword()) :: {:ok, CV.t()} | {:error, Ecto.Changeset.t()}
  def create_cv(attrs, opts \\ []) do
    attrs
    |> Map.fetch!(:applicant)
    |> Ecto.build_assoc(:cvs)
    |> CV.changeset(Map.delete(attrs, :applicant), opts)
    |> Repo.insert()
  end

  @doc """
  Updates a cv.

  ## Examples

      iex> update_cv(cv, %{field: new_value})
      {:ok, %CV{}}

      iex> update_cv(cv, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_cv(CV.t(), map(), keyword()) :: {:ok, CV.t()} | {:error, Ecto.Changeset.t()}
  def update_cv(%CV{} = cv, attrs, opts \\ []) do
    cv
    |> CV.changeset(attrs, opts)
    |> Repo.update()
  end

  @doc """
  Deletes a cv.

  ## Examples

      iex> delete_cv(cv)
      {:ok, %CV{}}

      iex> delete_cv(cv)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_cv(CV.t()) :: {:ok, CV.t()} | {:error, Ecto.Changeset.t()}
  def delete_cv(%CV{} = cv) do
    Repo.delete(cv)
  end

  @doc """
  Returns `true` when User is owner of given CV.
  """
  @spec can_user_edit_cv?(CV.t(), User.t()) :: boolean()
  def can_user_edit_cv?(%CV{} = cv, %User{} = user) do
    cv.applicant_id == user.id or user.role == :admin
  end

  @spec get_cvs_by_user_id(integer(), map()) :: Scrivener.Page.t()
  def get_cvs_by_user_id(user_id, options) do
    from(cv in CV)
    |> where([cv], cv.applicant_id == ^user_id)
    |> preload(:applicant)
    |> Repo.paginate(page: options["page"], page_size: options["page_size"])
  end

  @spec search_cvs(map()) :: Scrivener.Page.t()
  def search_cvs(options) do
    CV
    |> where([cv], cv.published)
    |> where([cv], cv.reviewed)
    |> QueryUtils.filter(:searchable, :search, options["text"])
    |> QueryUtils.filter(:employment_types, :intersection, options["employment_types"])
    |> QueryUtils.filter(:work_schedules, :intersection, options["work_schedules"])
    |> QueryUtils.filter(:field_of_art, :eq, options["field_of_art"])
    # |> QueryUtils.filter(:years_of_work_experience, :not_lt, options["min_years_of_work_experience"])
    |> filter_work_experience(options["min_years_of_work_experience"])
    |> filter_education(options["education"])
    |> preload(:applicant)
    |> Repo.paginate(page: options["page"], page_size: options["page_size"])
  end

  defp filter_education(query, nil), do: query

  defp filter_education(query, education) do
    educations = smaller_educations(education)

    from(cv in query,
      where:
        fragment(
          "EXISTS (SELECT * FROM unnest(?) AS education WHERE education->>'level' = ANY(?))",
          cv.educations,
          ^educations
        )
    )
  end

  defp filter_work_experience(query, nil), do: query

  defp filter_work_experience(query, min_years_of_work_experience) do
    from(cv in query,
      where:
        fragment(
          "(SELECT SUM(EXTRACT(EPOCH FROM (COALESCE(TO_DATE(job->>'end_date', 'YYYY-MM-DD'), NOW()) - TO_DATE(job->>'start_date', 'YYYY-MM-DD'))) / (60 * 60 * 24 * 365)) FROM unnest(?) AS job) > ?",
          cv.jobs,
          ^min_years_of_work_experience
        )
    )
  end

  @educations Enum.map(Cen.Enums.educations(), &to_string/1)

  defp smaller_educations(:none), do: @educations
  defp smaller_educations(education), do: Enum.drop_while(@educations, &(&1 != education))

  @spec list_unreviewed_cvs(map()) :: Scrivener.Page.t()
  def list_unreviewed_cvs(params) do
    CV
    |> where([cv], not cv.reviewed)
    |> preload(:applicant)
    |> Repo.paginate(page: params["page"], page_size: params["page_size"])
  end
end
