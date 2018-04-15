defmodule StormchatWeb.Router do
  use StormchatWeb, :router

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

  scope "/", StormchatWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/chats", PageController, :chat

    resources "/locations", LocationController, only: [:index]
    resources "/registration", UserController

    get    "/login",  SessionController, :new
    post   "/login",  SessionController, :create
    delete "/logout", SessionController, :delete

  end

  # Other scopes may use custom stacks.
   scope "/api/v1", StormchatWeb do
     pipe_through :api
     
     resources "/posts/:topic", PostController, except: [:new, :edit]
   end

end
