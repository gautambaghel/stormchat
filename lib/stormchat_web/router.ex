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

  scope "/auth", StormchatWeb do
      pipe_through :browser

      get "/:provider", AuthController, :request
      get "/:provider/callback", AuthController, :callback
  end

  scope "/api/v1", StormchatWeb do
     pipe_through :api

     resources "/posts/:topic", PostController, except: [:new, :edit]
     post "/posts/mobile/:topic", PostController, :mobile

     get "/alerts/:location", PageController, :alert
     get "/alerts/mobile/:location", PageController, :mobile

     post "/new_user", TokenController, :new
     post "/edit_user", TokenController, :edit
     post "/token", TokenController, :create
     delete "/token", TokenController, :delete
  end

end
