defmodule CenWeb.UploadsController do
  use CenWeb, :controller_with_specs

  alias Cen.Uploads
  alias CenWeb.Schemas.ChangesetErrorsResponse
  alias CenWeb.Schemas.GenericErrorResponse
  alias CenWeb.Schemas.ImageUploadRequest

  plug CenWeb.Plugs.CastAndValidate

  action_fallback CenWeb.FallbackController

  tags ["uploads"]

  security [%{"user_auth" => []}]

  operation :upload_image,
    summary: "Upload an image",
    request_body: {"The message", "multipart/form-data", ImageUploadRequest},
    responses: [
      created:
        {"Image uploaded", nil, nil,
         headers: %{
           "location" => %OpenApiSpex.Header{
             description: "Path to uploaded image",
             example: "/path/to/image"
           }
         }},
      unprocessable_entity: {"Changeset errors", "application/json", ChangesetErrorsResponse},
      unauthorized: {"Unauthorized", "application/json", GenericErrorResponse}
    ]

  @spec upload_image(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def upload_image(conn, params) do
    file = params["image"]

    case Uploads.save_image(file) do
      {:ok, path} ->
        conn
        |> put_resp_header("location", "/uploads/#{path}")
        |> resp(:created, "")

      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, reason: reason)
    end
  end
end
