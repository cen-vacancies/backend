defmodule CenWeb.ChatChannelTest do
  use CenWeb.ChannelCase

  import Cen.AccountsFixtures
  import Cen.CommunicationsFixtures

  describe "bad connection" do
    test "can't connect if not a member of the chat" do
      user = user_fixture(%{role: "applicant"})
      chat = chat_fixture()
      topic = "chat:#{chat.cv_id}:#{chat.vacancy_id}"

      assert {:error, _} =
               CenWeb.UserSocket
               |> socket("user", %{current_user: user})
               |> subscribe_and_join(CenWeb.ChatChannel, topic)
    end
  end

  describe "good connection" do
    setup do
      user = user_fixture(%{role: "applicant"})
      chat = chat_fixture_by_users(applicant: user)
      topic = "chat:#{chat.cv_id}:#{chat.vacancy_id}"

      {:ok, _reply, socket} =
        CenWeb.UserSocket
        |> socket("user", %{current_user: user})
        |> subscribe_and_join(CenWeb.ChatChannel, topic)

      %{socket: socket}
    end

    test "new_message broadcasts to chat:cv_id:vacancy_id", %{socket: socket} do
      ref = push(socket, "new_message", %{"text" => "Hello"})

      assert_reply ref, :ok
      assert_broadcast "new_message", %{text: "Hello"}
    end

    test "new_message returns an error when message is invalid", %{socket: socket} do
      ref = push(socket, "new_message", %{"text" => ""})

      assert_reply ref, :error
    end
  end
end
