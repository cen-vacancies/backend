defmodule CenWeb.Plugs.AccessRules do
  @moduledoc false
  import Plug.Conn

  @type init_params :: {(... -> boolean()), [atom()], module(), term()}

  @spec init(keyword()) :: init_params()
  def init(options) do
    fallback = Keyword.fetch!(options, :fallback)

    verify_fun = Keyword.fetch!(options, :verify_fun)
    args_keys = Keyword.fetch!(options, :args_keys)

    reason = Keyword.fetch!(options, :reason)

    {verify_fun, args_keys, fallback, reason}
  end

  @spec call(Plug.Conn.t(), init_params()) :: Plug.Conn.t()
  def call(conn, {verify_fun, args_keys, fallback, reason}) do
    args = fetch_args(conn, args_keys)

    if apply(verify_fun, args) do
      conn
    else
      conn |> fallback.call({:error, :forbidden, reason}) |> halt()
    end
  end

  defp fetch_args(%{assigns: assigns}, args_keys) do
    Enum.map(args_keys, &Map.fetch!(assigns, &1))
  end
end
