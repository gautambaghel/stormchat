defmodule StormchatWeb.TokenController do
  use StormchatWeb, :controller

  alias Stormchat.Accounts
  alias Stormchat.Accounts.User

  action_fallback StormchatWeb.FallbackController

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
