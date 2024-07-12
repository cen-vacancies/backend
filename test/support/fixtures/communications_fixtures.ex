defmodule Cen.CommunicationsFixtures do
  @moduledoc false

  alias Cen.AccountsFixtures
  alias Cen.Communications.Chat

  @spec chat_fixture(Enum.t()) :: Chat.t()
  def chat_fixture(attrs \\ %{}) do
    {:ok, chat} =
      attrs
      |> Enum.into(%{
        cv: Cen.ApplicantsFixtures.cv_fixture(),
        vacancy: Cen.EmployersFixtures.vacancy_fixture()
      })
      |> Cen.Communications.create_chat()

    chat
  end

  @spec chat_fixture_by_users(Keyword.t()) :: Chat.t()
  def chat_fixture_by_users(options) do
    employer = Keyword.get(options, :employer) || AccountsFixtures.user_fixture(%{role: "employer"})
    applicant = Keyword.get(options, :applicant) || AccountsFixtures.user_fixture(%{role: "applicant"})

    chat_fixture(%{
      cv:
        Cen.ApplicantsFixtures.cv_fixture(%{
          applicant: applicant
        }),
      vacancy:
        Cen.EmployersFixtures.vacancy_fixture(%{
          organization:
            Cen.EmployersFixtures.organization_fixture(%{
              employer: employer
            })
        })
    })
  end
end
