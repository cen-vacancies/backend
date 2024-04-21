defmodule Cen.Applicants do
  @moduledoc """
  The Applicants context.
  """

  import Ecto.Query, warn: false

  alias Cen.Accounts.User
  alias Cen.Applicants.CV
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
  @spec create_cv(map()) :: {:ok, CV.t()} | {:error, Ecto.Changeset.t()}
  def create_cv(attrs \\ %{}) do
    attrs
    |> Map.fetch!(:applicant)
    |> Ecto.build_assoc(:cvs)
    |> CV.changeset(Map.delete(attrs, :applicant))
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
  @spec update_cv(CV.t(), map()) :: {:ok, CV.t()} | {:error, Ecto.Changeset.t()}
  def update_cv(%CV{} = cv, attrs) do
    cv
    |> CV.changeset(attrs)
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
    cv.applicant_id == user.id
  end
end
