defmodule Cen.Uploads do
  @moduledoc false

  @spec save_image(Plug.Upload.t()) ::
          {:ok, String.t()}
          | {:error, :not_image}
          | {:error, :mime_not_found}
          | {:error, :file.posix()}
  def save_image(%Plug.Upload{path: path, content_type: "image/" <> _rest = content_type}) do
    with {:ok, extension} <- mime_to_extenson(content_type),
         filename = "#{calculate_hash(path)}.#{extension}",
         destination = Path.join(upload_path(), filename),
         :ok <- save(path, destination) do
      {:ok, filename}
    end
  end

  def save_image(%Plug.Upload{}), do: {:error, :not_image}

  defp mime_to_extenson(type) do
    case MIME.extensions(type) do
      [] -> {:error, :mime_not_found}
      [extension | _rest] -> {:ok, extension}
    end
  end

  defp calculate_hash(file_path) do
    file_path
    |> File.stream!(2048)
    |> Enum.reduce(:crypto.hash_init(:sha), &:crypto.hash_update(&2, &1))
    |> :crypto.hash_final()
    |> Base.encode16()
    |> String.downcase()
  end

  # This function requires disabling the Traversal.FileModule security check.
  # sobelow_skip ["Traversal.FileModule"]
  defp save(source_file, destination_file) do
    File.cp(source_file, destination_file)
  end

  @spec upload_path() :: String.t()
  def upload_path do
    :cen
    |> Application.get_env(Cen.Uploads)
    |> Keyword.fetch!(:path)
  end
end
