defmodule StormchatWeb.TokenController do
  use StormchatWeb, :controller

  alias Stormchat.Accounts
  alias Stormchat.Accounts.User

  action_fallback StormchatWeb.FallbackController

  def new(conn, %{"name"=> name, "email" => email, "pass" => pass,
                  "location" => location, "subscribe" => subscribe}) do
      user_params = %{"name"=> name, "email" => email, "password" => pass,
                      "location" => location, "subscribed" => subscribe}

      case Accounts.create_user(user_params) do
        {:ok, user} ->
           token = Phoenix.Token.sign(conn, "auth token", user.id)
           conn
             |> put_status(:created)
             |> render("token.json", user: user, token: token)
        {:error, changeset} ->
           err =
           try do
             [email: {msg, []}] = changeset.errors
             err = "Email " <> msg <> " !"
           catch
             _ ->
             err = "Error in creating user please verify the info entered"
           end
           conn
             |> put_status(:unprocessable_entity)
             |> render("error.json", error: err)
      end
  end

  def create(conn, %{"email" => email, "pass" => pass}) do
    with {:ok, %User{} = user} <- Accounts.get_and_auth_user(email, pass) do
      token = Phoenix.Token.sign(conn, "auth token", user.id)
      conn
        |> put_status(:created)
        |> render("token.json", user: user, token: token)
    else
      err ->
      {:error, err} = err
      conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", error: err)
    end
  end

  def delete(conn, _params) do
      conn
        |> render("delete_token.json")
  end


end
