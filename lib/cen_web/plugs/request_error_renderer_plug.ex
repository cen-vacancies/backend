defmodule CenWeb.Plugs.RequestErrorRendererPlug do
  @moduledoc false
  @behaviour Plug

  import Plug.Conn

  @impl Plug
  def init(errors), do: errors

  @impl Plug
  def call(conn, errors) do
    response = %{
      errors: Enum.reduce(errors, %{}, &render_error/2)
    }

    json = Jason.encode!(response)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(422, json)
  end

  @spec render_error(OpenApiSpex.Cast.Error.t(), map()) :: map()
  def render_error(%{path: path} = error, result) do
    do_render_error(path, error, result)
  end

  @spec do_render_error(list(), OpenApiSpex.Cast.Error.t(), map()) :: map()
  defp do_render_error([], error, result) do
    error_string = to_string(error)
    Map.update(result, "self", [error_string], &[error_string | &1])
  end

  @spec do_render_error(list(), OpenApiSpex.Cast.Error.t(), map()) :: map()
  defp do_render_error([value], error, result) do
    error_string = to_string(error)
    Map.update(result, value, [error_string], &[error_string | &1])
  end

  defp do_render_error([head | rest], error, result) do
    Map.update(
      result,
      head,
      do_render_error(rest, error, %{}),
      fn
        nested_result when is_map(nested_result) -> do_render_error(rest, error, nested_result)
        _ignored_result -> do_render_error(rest, error, %{})
      end
    )
  end
end
