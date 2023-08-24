defmodule AuthbotWeb.Router do
  use AuthbotWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :put_root_layout, html: {AuthbotWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PlugClacks
  end

  scope "/", AuthbotWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/:guild_id/step1", PageController, :step1
    get "/step2", PageController, :step2
    get "/finished", PageController, :finished
  end

  scope "/auth", AuthbotWeb do
    pipe_through :browser

    # sso methods
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
