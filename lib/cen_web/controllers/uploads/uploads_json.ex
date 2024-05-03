defmodule CenWeb.UploadsJSON do
  @spec error(map()) :: map()
  def error(%{reason: reason}) do
    %{"errors" => %{"image" => [format_error(reason)]}}
  end

  defp format_error(:not_image), do: "Wrong image type"
  defp format_error(:mime_not_found), do: "Unexpected mime type"
end
