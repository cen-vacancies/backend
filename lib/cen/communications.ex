defmodule Cen.Communications do
  @moduledoc false
  import Ecto.Query

  alias Cen.Accounts.User
  alias Cen.Applicants.CV
  alias Cen.Communications.Chat
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
end
