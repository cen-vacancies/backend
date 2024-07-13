defmodule Cen.CommunicationsTest do
  use Cen.DataCase

  import Cen.CommunicationsFixtures

  alias Cen.AccountsFixtures
  alias Cen.Communications
  alias Cen.Communications.Chat
  alias Cen.Communications.Message

  describe "create_chat/1" do
    test "creates chat" do
      cv = Cen.ApplicantsFixtures.cv_fixture()
      vacancy = Cen.EmployersFixtures.vacancy_fixture()

      assert {:ok, chat} = Communications.create_chat(%{cv: cv, vacancy: vacancy})

      assert %Chat{} = chat
    end

    test "can't create multiple chats with same cv and vacancy" do
      cv = Cen.ApplicantsFixtures.cv_fixture()
      vacancy = Cen.EmployersFixtures.vacancy_fixture()

      chat_fixture(cv: cv, vacancy: vacancy)

      assert {:error, %Ecto.Changeset{valid?: false}} = Communications.create_chat(%{cv: cv, vacancy: vacancy})
    end

    test "can create multiple chats with same users but different cv and vacancy" do
      employer = AccountsFixtures.user_fixture(role: "employer")
      applicant = AccountsFixtures.user_fixture(role: "applicant")

      cv_1 = Cen.ApplicantsFixtures.cv_fixture(applicant: applicant)
      cv_2 = Cen.ApplicantsFixtures.cv_fixture(applicant: applicant)

      vacancy_1 =
        Cen.EmployersFixtures.vacancy_fixture(
          organization: Cen.EmployersFixtures.organization_fixture(employer: employer)
        )

      vacancy_2 =
        Cen.EmployersFixtures.vacancy_fixture(
          organization: Cen.EmployersFixtures.organization_fixture(employer: employer)
        )

      assert {:ok, chat_1} = Communications.create_chat(%{cv: cv_1, vacancy: vacancy_1})
      assert {:ok, chat_2} = Communications.create_chat(%{cv: cv_2, vacancy: vacancy_2})

      assert %Chat{} = chat_1
      assert %Chat{} = chat_2
    end
  end

  describe "get_chats_by_user/1" do
    test "returns chats for user" do
      employer_1 = AccountsFixtures.user_fixture(role: "employer")
      employer_2 = AccountsFixtures.user_fixture(role: "employer")

      applicant = AccountsFixtures.user_fixture(role: "applicant")

      %{id: chat_1_id} = chat_fixture_by_users(employer: employer_1, applicant: applicant)
      %{id: chat_2_id} = chat_fixture_by_users(employer: employer_2, applicant: applicant)

      assert %{entries: [%{id: ^chat_1_id}, %{id: ^chat_2_id}]} = Communications.get_chats_by_user(applicant.id)
      assert %{entries: [%{id: ^chat_1_id}]} = Communications.get_chats_by_user(employer_1.id)
      assert %{entries: [%{id: ^chat_2_id}]} = Communications.get_chats_by_user(employer_2.id)
    end

    test "returns chats for user with pagination" do
      employer = AccountsFixtures.user_fixture(role: "employer")
      applicant = AccountsFixtures.user_fixture(role: "applicant")

      chat_fixture_by_users(employer: employer, applicant: applicant)
      chat_fixture_by_users(employer: employer, applicant: applicant)

      assert %{entries: [%Chat{}], page_number: 1, page_size: 1} =
               Communications.get_chats_by_user(applicant.id, %{"page" => 1, "page_size" => 1})
    end
  end

  describe "create_message/4" do
    test "creates message" do
      user = AccountsFixtures.user_fixture()
      chat = chat_fixture_by_users(applicant: user)

      assert {:ok, %Communications.Message{}} =
               Communications.create_message(user.id, chat.cv.id, chat.vacancy.id, %{text: "Hello"})
    end

    test "can't create empty message" do
      user = AccountsFixtures.user_fixture()
      chat = chat_fixture_by_users(applicant: user)

      assert {:error, %Ecto.Changeset{valid?: false}} =
               Communications.create_message(user.id, chat.cv.id, chat.vacancy.id, %{text: ""})
    end

    test "can't create message for chat that user is not part of" do
      user = AccountsFixtures.user_fixture()
      chat = chat_fixture()

      assert {:error, %Ecto.Changeset{valid?: false}} =
               Communications.create_message(user.id, chat.cv.id, chat.vacancy.id, %{text: "Hello"})
    end
  end

  describe "list_messages/2" do
    test "returns messages for chat" do
      user = AccountsFixtures.user_fixture()
      chat = chat_fixture_by_users(applicant: user)

      {:ok, %{id: message_id}} = Communications.create_message(user.id, chat.cv.id, chat.vacancy.id, %{text: "Hello"})

      assert %{entries: [%Message{id: ^message_id}]} = Communications.list_messages(chat)
    end

    test "returns messages for chat with pagination" do
      user = AccountsFixtures.user_fixture()
      chat = chat_fixture_by_users(applicant: user)

      Communications.create_message(user.id, chat.cv.id, chat.vacancy.id, %{text: "Hello"})
      Communications.create_message(user.id, chat.cv.id, chat.vacancy.id, %{text: "Hello"})

      assert %{entries: [%Message{}], page_number: 1, page_size: 1} =
               Communications.list_messages(chat, %{"page" => 1, "page_size" => 1})
    end

    test "returns only messages for chat" do
      user = AccountsFixtures.user_fixture()
      chat_1 = chat_fixture_by_users(applicant: user)
      chat_2 = chat_fixture_by_users(applicant: user)

      Communications.create_message(user.id, chat_1.cv.id, chat_1.vacancy.id, %{text: "Hello"})
      Communications.create_message(user.id, chat_2.cv.id, chat_2.vacancy.id, %{text: "Hello"})

      assert %{entries: [%Message{}]} = Communications.list_messages(chat_1)
    end

    test "returns new messages first" do
      user = AccountsFixtures.user_fixture()
      chat = chat_fixture_by_users(applicant: user)

      {:ok, %{id: message_1_id}} = Communications.create_message(user.id, chat.cv.id, chat.vacancy.id, %{text: "Hello"})
      {:ok, %{id: message_2_id}} = Communications.create_message(user.id, chat.cv.id, chat.vacancy.id, %{text: "Hello"})

      assert %{entries: [%Message{id: ^message_2_id}, %Message{id: ^message_1_id}]} = Communications.list_messages(chat)
    end
  end
end
