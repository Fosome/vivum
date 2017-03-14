defmodule Vivum.Router do
  use Vivum.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Vivum do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/sign_up", UserController, :new

    resources "/users", UserController, only: [:create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Vivum do
  #   pipe_through :api
  # end
end
