defmodule StormchatWeb.TokenController do
  use StormchatWeb, :controller

  alias Stormchat.Accounts
  alias Stormchat.Accounts.User
  alias Stormchat.Accounts.AuthUser

  action_fallback StormchatWeb.FallbackController

  def new(conn, %{"name"=> name, "email" => email, "password" => password,
                  "location" => location, "subscribe" => subscribe}) do
      user_params = %{"name"=> name, "email" => email, "password" => password,
                      "location" => location, "subscribed" => subscribe}

      case Accounts.create_user(user_params) do
        {:ok, user} ->
           token = Phoenix.Token.sign(conn, "auth token", user.id)
           conn
             |> put_status(:created)
             |> render("token.json", user: user, token: token)
        {:error, changeset} ->
           err = StormchatWeb.ChangesetView.translate_errors(changeset)
           conn
             |> put_status(:unprocessable_entity)
             |> render("error.json", error: err)
      end
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.get_and_auth_user(email, password) do
     {:ok, %User{} = user} ->
        token = Phoenix.Token.sign(conn, "auth token", user.id)
        conn
          |> put_status(:created)
          |> render("token.json", user: user, token: token)
     {:error, err} ->
        conn
          |> put_status(:unprocessable_entity)
          |> render("error.json", error: err)
    end
  end

  def new(conn, %{"auth" => auth, "provider" => provider, "name" => name}) do
    case Accounts.get_auth_user!(auth, provider, name) do
     {:ok, %AuthUser{} = user} ->
        conn
          |> put_status(:created)
          |> render("token.json", user: user, token: nil)
     {:error, err} ->
        conn
          |> put_status(:unprocessable_entity)
          |> render("error.json", error: err)
    end
  end

  def create(conn, %{"auth" => auth,"email" => email, "location" => location, "subscribed" => subscribed}) do
    case Accounts.add_authuser_data!(auth, email, location, subscribed) do
     {:ok, %AuthUser{} = authUser} ->
        # email needs to be unique so auth is good, i know it sucks
        # but we'll be extracting all the data from AuthUser just Phoenix needs
        # unique user.id for Token sign in
        password = gen_password() |> Comeonin.Argon2.hashpwsalt
        email = auth <> "@" <> authUser.provider <> ".com"
        changeset = User.changeset(%User{}, %{name: authUser.name, email: email,
        subscribed: subscribed, location: location, crypted_password: password})
        {:ok, user} = Accounts.add_or_get(changeset, email)
        token = Phoenix.Token.sign(conn, "auth token", user.id)
        Accounts.add_authuser_id!(auth, user.id)

        conn
          |> put_status(:created)
          |> render("token_mobile.json", %{user: authUser, token: token, auth_id: user.id})
     {:error, err} ->
        conn
          |> put_status(:unprocessable_entity)
          |> render("error.json", error: err)
    end
  end

  defp gen_password() do
    min = String.to_integer("100000", 36)
    max = String.to_integer("ZZZZZZ", 36)

    max
    |> Kernel.-(min)
    |> :rand.uniform()
    |> Kernel.+(min)
    |> Integer.to_string(36)
   end


  def delete(conn, _params) do
    conn
      |> render("delete_token.json")
  end

end
