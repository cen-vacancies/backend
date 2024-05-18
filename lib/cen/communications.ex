defmodule Cen.Communications do
  @moduledoc false

  import Ecto.Query

  alias Cen.Accounts.User
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

  @spec get_chats_by_user(User.t()) :: [Chat.t()]
  def get_chats_by_user(user) do
    query =
      from chat in Chat,
        left_join: cv in assoc(chat, :cv),
        left_join: applicant in assoc(cv, :applicant),
        left_join: vacancy in assoc(chat, :vacancy),
        left_join: organization in assoc(vacancy, :organization),
        left_join: employer in assoc(organization, :employer),
        where: applicant.id == ^user.id or employer.id == ^user.id,
        preload: [cv: {cv, applicant: applicant}, vacancy: {vacancy, organization: {organization, employer: employer}}]

    Repo.all(query)
  end

  @spec create_chat(%{cv: CV.t(), vacancy: Vacancy.t()}) :: Chat.t()
  def create_chat(%{cv: %CV{id: cv_id}, vacancy: %Vacancy{id: vacancy_id}}) do
    Repo.insert(%Chat{cv_id: cv_id, vacancy_id: vacancy_id})
  end

  @spec list_messages(Chat.t()) :: [Message.t()]
  def list_messages(chat) do
    query =
      from message in Message,
        where: message.chat_id == ^chat.id

    Repo.all(query)
  end

  @spec create_message(Chat.t(), map()) :: {:ok, Message.t()} | {:error, Ecto.Changeset.t()}
  def create_message(chat, attrs) do
    chat
    |> Ecto.build_assoc(:messages)
    |> Message.changeset(attrs)
    |> Repo.insert()
  end
end
