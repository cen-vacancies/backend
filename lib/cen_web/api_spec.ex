defmodule CenWeb.ApiSpec do
  @moduledoc false
  @behaviour OpenApiSpex.OpenApi

  alias CenWeb.Endpoint
  alias CenWeb.Router
  alias OpenApiSpex.Components
  alias OpenApiSpex.Info
  alias OpenApiSpex.OpenApi
  alias OpenApiSpex.Paths
  alias OpenApiSpex.SecurityScheme
  alias OpenApiSpex.Server

  @impl OpenApiSpex.OpenApi
  def spec do
    OpenApiSpex.resolve_schema_modules(%OpenApi{
      servers: [Server.from_endpoint(Endpoint)],
      info: %Info{
        title: to_string(Application.spec(:my_app, :description)),
        version: to_string(Application.spec(:my_app, :vsn))
      },
      paths: Paths.from_router(Router),
      components: %Components{securitySchemes: %{"authorization" => %SecurityScheme{type: "http", scheme: "bearer"}}}
    })
  end
end
