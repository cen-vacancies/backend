defmodule CenWeb.ChatChannel do
  @moduledoc false
  use CenWeb, :channel

  alias Cen.Communications

  @impl true
  def join("chat:" <> ids, _payload, socket) do
    case parse_ids(ids) do
      {:ok, cv_id, vacancy_id} -> {:ok, assign(socket, cv_id: cv_id, vacancy_id: vacancy_id)}
      {:error, reason} -> {:error, %{reason: reason}}
    end

    with {:ok, cv_id, vacancy_id} <- parse_ids(ids),
         :ok <- check_user_in_db_chat(socket.assigns.current_user.id, cv_id, vacancy_id) do
      {:ok, assign(socket, cv_id: cv_id, vacancy_id: vacancy_id)}
    else
      {:error, reason} -> {:error, %{reason: reason}}
    end
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat:lobby).
  @impl true
  def handle_in("new_message", payload, socket) do
    case Communications.create_message(
           socket.assigns.current_user.id,
           socket.assigns.cv_id,
           socket.assigns.vacancy_id,
           payload
         ) do
      {:ok, message} ->
        broadcast(socket, "new_message", format_message(message))
        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, format_changeset(changeset)}, socket}
    end
  end

  defp parse_ids(ids) do
    parsed_ids =
      ids
      |> String.split(":")
      |> list_to_integers()

    with {:ok, [cv_id, vacancy_id]} <- parsed_ids do
      {:ok, cv_id, vacancy_id}
    end
  end

  defp list_to_integers(list) do
    result =
      Enum.reduce_while(list, {:ok, []}, fn x, {:ok, acc} ->
        case Integer.parse(x) do
          {int, ""} -> {:cont, {:ok, [int | acc]}}
          _ -> {:halt, {:error, "invalid ids"}}
        end
      end)

    case result do
      {:ok, ids} -> {:ok, Enum.reverse(ids)}
      {:error, reason} -> {:error, reason}
    end
  end

  defp check_user_in_db_chat(user_id, cv_id, vacancy_id) do
    if Cen.Communications.chat_member?(user_id, cv_id, vacancy_id) do
      :ok
    else
      {:error, "is not a chat member"}
    end
  end

  defp format_message(message) do
    CenWeb.ChatJSON.show_message(%{message: message})
  end

  defp format_changeset(changeset) do
    CenWeb.ChangesetJSON.error(%{changeset: changeset})
  end
end
