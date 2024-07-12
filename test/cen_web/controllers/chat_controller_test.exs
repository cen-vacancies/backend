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

      assert [%{"id" => ^chat_id1}, %{"id" => ^chat_id2}] = json["data"]
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
end
