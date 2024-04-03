defmodule CenWeb.Router do
  use CenWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CenWeb.Layouts, :root}
    plug :protect_from_forgery

    plug :put_secure_browser_headers, %{
      "content-security-policy" =>
        "default-src 'self' https://cdnjs.cloudflare.com 'unsafe-inline'; img-src 'self' data: blob:; style-src 'self' https://cdnjs.cloudflare.com 'unsafe-inline'; font-src 'self'"
    }

    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: CenWeb.ApiSpec
  end

  scope "/" do
    pipe_through :browser
    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
  end

  scope "/api" do
    pipe_through [:api]
    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  scope "/api", CenWeb do
    pipe_through :api

    get "/health/check", HealthCheckController, :check
  end

  scope "/api", CenWeb do
    pipe_through :api

    post "/users", UserController, :create

    get "/users/:user_id", UserController, :show
    patch "/users/:user_id/info", UserController, :update_info
    delete "/users/:user_id", UserController, :delete
  end

  scope "/api", CenWeb do
    pipe_through :api

    post "/tokens", TokenController, :create
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:cen, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CenWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
