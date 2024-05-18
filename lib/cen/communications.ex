defmodule Cen.Communications do
  @moduledoc false
  import Ecto.Query

  alias Cen.Accounts.User
  alias Cen.Applicants.CV
  alias Cen.Communications.Chat
  alias Cen.Communications.Message
  alias Cen.Employers.Vacancy
  alias Cen.Repo

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