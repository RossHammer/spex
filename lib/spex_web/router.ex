defmodule SpexWeb.Router do
  use SpexWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SpexWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: SpexWeb.ApiSpec
  end

  scope "/" do
    pipe_through :browser

    get "/", SpexWeb.PageController, :home
    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
  end

  scope "/api" do
    pipe_through :api
    resources "/users", SpexWeb.UserController, only: [:update]
    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:spex, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SpexWeb.Telemetry
    end
  end
end
