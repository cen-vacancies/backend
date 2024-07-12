defmodule ChatControllerTest do
  use CenWeb.ConnCase, async: true

  import Cen.CommunicationsFixtures

  alias Cen.AccountsFixtures
  alias CenWeb.Schemas.ChatsListResponse

  describe "GET /chats" do
    setup :register_and_log_in_user

    test "returns a list of chats for applicant", %{conn: conn, user: user} do
      %{id: chat_id} = create_chat(applicant: user)
      conn = get(conn, "/api/chats")

      json = json_response(conn, 200)

      assert_schema ChatsListResponse, json

      assert [%{"id" => ^chat_id}] = json["data"]
    end

    test "returns a list of chats for employer with multiple chats", %{conn: conn, user: user} do
      %{id: chat_id1} = create_chat(employer: user)
      %{id: chat_id2} = create_chat(employer: user)
      conn = get(conn, "/api/chats")

      json = json_response(conn, 200)

      assert_schema ChatsListResponse, json

      assert [%{"id" => ^chat_id1}, %{"id" => ^chat_id2}] = json["data"]
    end

    test "returns a list of chats for employer with multiple chats for different employers", %{conn: conn, user: user} do
      %{id: chat_id1} = create_chat(employer: user)
      create_chat([])
      conn = get(conn, "/api/chats")

      json = json_response(conn, 200)

      assert_schema ChatsListResponse, json

      assert [%{"id" => ^chat_id1}] = json["data"]
    end
  end

  defp create_chat(options) do
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
