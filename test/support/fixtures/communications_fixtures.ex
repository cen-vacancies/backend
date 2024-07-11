defmodule Cen.CommunicationsFixtures do
  @moduledoc false

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
end
