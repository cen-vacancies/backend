defmodule CenWeb.UserSocket do
  use Phoenix.Socket

  alias Cen.Accounts

  # A Socket handler
  #
  # It's possible to control the websocket connection and
  # assign values that can be accessed by your channel topics.

  ## Channels

  channel "chat:*", CenWeb.ChatChannel

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error` or `{:error, term}`. To control the
  # response the client receives in that case, [define an error handler in the
  # websocket
  # configuration](https://hexdocs.pm/phoenix/Phoenix.Endpoint.html#socket/3-websocket-configuration).
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  @impl Phoenix.Socket
  def connect(params, socket, _connect_info) do
    {:ok, assign(socket, :current_user, authorize(params))}
  end

  # Socket IDs are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     Elixir.CenWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  @impl Phoenix.Socket
  def id(_socket), do: nil

  defp authorize(%{"token" => token}) do
    case Accounts.fetch_user_by_api_token(token) do
      {:ok, user, _claims} -> user
      _err -> nil
    end
  end

  defp authorize(_payload), do: nil
end
