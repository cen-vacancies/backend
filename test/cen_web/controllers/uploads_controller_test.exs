defmodule CenWeb.UploadsControllerTest do
  use CenWeb.ConnCase, async: true

  alias CenWeb.Schemas.ChangesetErrorsResponse
  alias CenWeb.Schemas.GenericErrorResponse

  setup %{conn: conn} do
    {:ok, conn: Plug.Conn.put_req_header(conn, "content-type", "multipart/form-data")}
  end

  describe "upload images" do
    @describetag :tmp_dir

    setup :register_and_log_in_user

    @image_data "abcdefg"

    setup %{tmp_dir: path} do
      uploads_dir = Path.join(path, "uploads")
      File.mkdir_p!(uploads_dir)

      Application.put_env(:cen, Cen.Uploads, path: uploads_dir)

      test_dir = Path.join(path, "test")
      File.mkdir_p!(test_dir)

      image_path = Path.join(test_dir, "image.png")
      File.write!(image_path, @image_data)

      image_upload = %Plug.Upload{path: image_path, content_type: "image/png", filename: "image.png"}

      {:ok, %{image_upload: image_upload}}
    end

    test "saves image", %{conn: conn, image_upload: image_upload} do
      conn_post = post(conn, ~p"/api/uploads/image", %{"image" => image_upload})

      response(conn_post, 201)

      image_location =
        conn_post
        |> Map.fetch!(:resp_headers)
        |> List.keyfind!("location", 0)
        |> elem(1)

      conn_get = get(conn, image_location)

      response = response(conn_get, 200)

      assert @image_data == response
    end

    test "returns error on non-image type", %{conn: conn} do
      image_upload = %Plug.Upload{content_type: "application/json"}

      conn = post(conn, ~p"/api/uploads/image", %{"image" => image_upload})

      json = json_response(conn, 422)
      assert_schema ChangesetErrorsResponse, json
    end

    test "returns error on wrong MIME types", %{conn: conn} do
      image_upload = %Plug.Upload{content_type: "wrong/mime"}

      conn = post(conn, ~p"/api/uploads/image", %{"image" => image_upload})

      json = json_response(conn, 422)
      assert_schema ChangesetErrorsResponse, json
    end

    test "returns error on non-authorized", %{conn: conn} do
      image_upload = %Plug.Upload{content_type: "application.json"}

      conn =
        conn
        |> delete_req_header("authorization")
        |> post(~p"/api/uploads/image", %{"image" => image_upload})

      json = json_response(conn, 401)
      assert_schema GenericErrorResponse, json
    end
  end
end
