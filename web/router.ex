defmodule Vivum.Router do
  use Vivum.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Vivum.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Vivum do
    pipe_through :browser # Use the default browser stack

    get "/",        PageController, :index
    get "/sign_up", UserController, :new

    resources "/sessions", SessionController, only: [:new, :create, :delete]

    resources "/users",  UserController,  only: [:create]
    resources "/plants", PlantController

    get "/search/new",     SearchController, :new
    get "/search/results", SearchController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", Vivum do
  #   pipe_through :api
  # end
end
