defmodule Cen.CommunicationsFixtures do
  @moduledoc false

  alias Cen.AccountsFixtures
  alias Cen.Communications.Chat

  @spec chat_fixture(Enum.t()) :: Chat.t()
  def chat_fixture(attrs \\ %{}) do
    attrs = Enum.into(attrs, %{cv: Cen.ApplicantsFixtures.cv_fixture(), vacancy: Cen.EmployersFixtures.vacancy_fixture()})

    {:ok, chat} = Cen.Communications.create_chat(attrs)

    chat
    |> Map.put(:cv, attrs.cv)
    |> Map.put(:vacancy, attrs.vacancy)
  end

  @spec chat_fixture_by_users(Keyword.t()) :: Chat.t()
  def chat_fixture_by_users(options) do
    employer = Keyword.get(options, :employer) || AccountsFixtures.user_fixture(%{role: "employer"})
    applicant = Keyword.get(options, :applicant) || AccountsFixtures.user_fixture(%{role: "applicant"})

    cv = Cen.ApplicantsFixtures.cv_fixture(%{applicant: applicant})

    vacancy =
      Cen.EmployersFixtures.vacancy_fixture(%{
        organization:
          Cen.EmployersFixtures.organization_fixture(%{
            employer: employer
          })
      })

    opts = %{cv: cv, vacancy: vacancy}

    opts
    |> chat_fixture()
    |> Map.merge(opts)
  end
end
