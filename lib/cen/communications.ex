defmodule Cen.Communications do
  @moduledoc false

  import Ecto.Query

  alias Cen.Applicants.CV
  alias Cen.Communications.Chat
  alias Cen.Communications.Interest
  alias Cen.Communications.Message
  alias Cen.Employers.Vacancy
  alias Cen.Repo

  @spec send_interest(atom(), integer(), integer()) :: {:ok, Interest.t()} | {:error, Ecto.Changeset.t()}
  def send_interest(user_role, cv_id, vacancy_id) do
    %Interest{cv_id: cv_id, vacancy_id: vacancy_id, from: user_role}
    |> Interest.changeset(%{})
    |> Repo.insert()
  end

  @spec get_interest!(integer()) :: Interest.t()
  def get_interest!(id) do
    Interest
    |> Repo.get!(id)
    |> Repo.preload(vacancy: [organization: [employer: []]], cv: [applicant: []])
  end

  # I dunno
  # @spec list_interests(integer(), String.t(), String.t(), map()) :: Scrivener.Page.t()
  # has no local return 🤷
  @spec list_interests(term(), term(), term(), term()) :: Scrivener.Page.t()
  def list_interests(user_id, user_role, interest_type, params)

  def list_interests(user_id, user_role, "sended", params) do
    user_id
    |> sended_interests_query(user_role)
    |> Repo.paginate(page: params["page"], page_size: params["page_size"])
  end

  def list_interests(user_id, user_role, "recieved", params) do
    user_id
    |> recieved_interests_query(user_role)
    |> Repo.paginate(page: params["page"], page_size: params["page_size"])
  end

  defp sended_interests_query(user_id, user_role) do
    from interest in interests_query(user_id),
      where: interest.from == ^user_role
  end

  defp recieved_interests_query(user_id, user_role) do
    from interest in interests_query(user_id),
      where: interest.from != ^user_role
  end

  defp interests_query(user_id) do
    from interest in Interest,
      left_join: cv in assoc(interest, :cv),
      left_join: applicant in assoc(cv, :applicant),
      left_join: vacancy in assoc(interest, :vacancy),
      left_join: organization in assoc(vacancy, :organization),
      left_join: employer in assoc(organization, :employer),
      where: applicant.id == ^user_id or employer.id == ^user_id,
      preload: [cv: {cv, applicant: applicant}, vacancy: {vacancy, organization: {organization, employer: employer}}]
  end

  @spec get_chats_by_user(integer(), map()) :: Scrivener.Page.t()
  def get_chats_by_user(user_id, params \\ %{}) do
    query =
      from chat in Chat,
        left_join: cv in assoc(chat, :cv),
        left_join: applicant in assoc(cv, :applicant),
        left_join: vacancy in assoc(chat, :vacancy),
        left_join: organization in assoc(vacancy, :organization),
        left_join: employer in assoc(organization, :employer),
        where: applicant.id == ^user_id or employer.id == ^user_id,
        preload: [cv: {cv, applicant: applicant}, vacancy: {vacancy, organization: {organization, employer: employer}}]

    Repo.paginate(query, page: params["page"], page_size: params["page_size"])
  end

  @spec create_chat(%{cv: CV.t(), vacancy: Vacancy.t()}) :: {:ok, Chat.t()} | {:error, Ecto.Changeset.t()}
  def create_chat(%{cv: %CV{id: cv_id}, vacancy: %Vacancy{id: vacancy_id}}) do
    %Chat{cv_id: cv_id, vacancy_id: vacancy_id}
    |> Chat.changeset(%{})
    |> Repo.insert()
  end

  @spec list_messages(Chat.t(), map()) :: Scrivener.Page.t()
  def list_messages(chat, params \\ %{}) do
    query =
      from message in Message,
        where: message.chat_id == ^chat.id,
        order_by: [desc: message.id]

    Repo.paginate(query, page: params["page"], page_size: params["page_size"])
  end

  @spec create_message(id, id, id, map()) :: {:ok, Message.t()} | {:error, Ecto.Changeset.t()}
        when id: integer() | String.t()
  def create_message(author_id, cv_id, vacancy_id, attrs) do
    transaction =
      Ecto.Multi.new()
      |> Ecto.Multi.run(:get_chat, fn repo, _changes ->
        query =
          from chat in Chat,
            where: chat.cv_id == ^cv_id and chat.vacancy_id == ^vacancy_id

        case repo.one(query) do
          nil ->
            %Chat{cv_id: cv_id, vacancy_id: vacancy_id}
            |> Chat.changeset(%{})
            |> repo.insert()

          chat ->
            {:ok, chat}
        end
      end)
      |> Ecto.Multi.run(:create_message, fn repo, %{get_chat: chat} ->
        chat
        |> Ecto.build_assoc(:messages)
        |> Message.set_author_id(author_id)
        |> Message.changeset(attrs)
        |> repo.insert()
      end)
      |> Repo.transaction()

    case transaction do
      {:ok, %{create_message: message}} -> {:ok, message}
      {:error, :create_message, changeset, _changes} -> {:error, changeset}
    end
  end

  def chat_member?(user_id, cv_id, vacancy_id) do
    query =
      from chat in Chat,
        left_join: cv in assoc(chat, :cv),
        left_join: applicant in assoc(cv, :applicant),
        left_join: vacancy in assoc(chat, :vacancy),
        left_join: organization in assoc(vacancy, :organization),
        left_join: employer in assoc(organization, :employer),
        where: cv.id == ^cv_id and vacancy.id == ^vacancy_id and (applicant.id == ^user_id or employer.id == ^user_id)

    Repo.all(query) != []
  end
end
