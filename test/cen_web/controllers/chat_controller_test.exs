defmodule ChatControllerTest do
  use CenWeb.ConnCase, async: true

  import Cen.CommunicationsFixtures

  alias CenWeb.Schemas.ChatsListResponse

  describe "GET /chats" do
    setup :register_and_log_in_user

    test "returns a list of chats for applicant", %{conn: conn, user: user} do
      %{id: chat_id} = chat_fixture_by_users(applicant: user)
      conn = get(conn, "/api/chats")

      json = json_response(conn, 200)

      assert_schema ChatsListResponse, json

      assert [%{"id" => ^chat_id}] = json["data"]
    end

    test "returns a list of chats for employer with multiple chats", %{conn: conn, user: user} do
      %{id: chat_id1} = chat_fixture_by_users(employer: user)
      %{id: chat_id2} = chat_fixture_by_users(employer: user)
      conn = get(conn, "/api/chats")

      json = json_response(conn, 200)

      assert_schema ChatsListResponse, json

      ids = Enum.map(json["data"], & &1["id"])

      assert Enum.member?(ids, chat_id1)
      assert Enum.member?(ids, chat_id2)
    end

    test "returns a list of chats for employer with multiple chats for different employers", %{conn: conn, user: user} do
      %{id: chat_id1} = chat_fixture_by_users(employer: user)
      chat_fixture()
      conn = get(conn, "/api/chats")

      json = json_response(conn, 200)

      assert_schema ChatsListResponse, json

      assert [%{"id" => ^chat_id1}] = json["data"]
    end
  end

  describe "POST /chats/send_message" do
    setup :register_and_log_in_user

    test "sends a message to a chat", %{conn: conn, user: user} do
      chat = chat_fixture_by_users(applicant: user)

      conn =
        post(conn, "/api/chats/send_message", %{"cv_id" => chat.cv.id, "vacancy_id" => chat.vacancy.id, "text" => "Hello"})

      json = json_response(conn, 200)

      assert_schema CenWeb.Schemas.MessageResponse, json
    end

    test "sends a message to a chat with invalid data", %{conn: conn, user: user} do
      chat = chat_fixture_by_users(applicant: user)

      conn =
        post(conn, "/api/chats/send_message", %{"cv_id" => chat.cv.id, "vacancy_id" => chat.vacancy.id, "text" => ""})

      json = json_response(conn, 422)

      assert_schema CenWeb.Schemas.ChangesetErrorsResponse, json
    end
  end
end
