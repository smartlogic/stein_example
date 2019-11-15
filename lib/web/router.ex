defmodule Web.Router do
  use Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Web.Plugs.FetchUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Web do
    pipe_through :browser

    get "/", PageController, :index

    get("/sign-in", SessionController, :new)

    post("/sign-in", SessionController, :create)

    delete("/sign-out", SessionController, :delete)
  end
end
