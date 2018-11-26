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
           error = convert_error_to_string(err)
           conn
             |> put_status(:unprocessable_entity)
             |> render("error.json", error: error)
      end
  end
  
  # We don't need the password again, we verify the user via token, but schema
  # requires password so we need to user a dummy password, no actual changes though
  def edit(conn, %{"name"=> name, "email" => email, "token" => token,
      "user_id" =>  userid, "location" => location, "subscribed" => subscribed}) do
      case Phoenix.Token.verify(conn, "auth token", token, max_age: 8640000) do
        {:ok, user_id} ->
            cond do
              userid != Kernel.inspect(user_id) ->
                     IO.inspect({:bad_match, userid, user_id})
                     conn |> render("error.json", msg: "Hax!")
              true ->
                with user <- Accounts.get_by_id!(user_id) do
                     attrs = %{"name"=> name, "email" => email, "password" => "dummy_password",
                               "location" => location, "subscribed" => subscribed}
                         
                     case Accounts.update_user_details!(user, attrs) do
                       {:ok, user} ->
                         token = Phoenix.Token.sign(conn, "auth token", user.id)
                         conn
                           |> put_status(:created)
                           |> render("token.json", user: user, token: token)
                       {:error, changeset} ->
                           err = StormchatWeb.ChangesetView.translate_errors(changeset)
                           error = convert_error_to_string(err)
                           conn
                             |> put_status(:unprocessable_entity)
                             |> render("error.json", error: error)
                     end
                end
            end

        {:error, err} ->
            conn |> render("error.json", error: err)
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
     {:ok, %AuthUser{} = authUser} ->
       email = auth <> "@" <> provider <> ".com"
       id = if Accounts.get_by_email!(email) == nil, do: "", else: Accounts.get_by_email!(email).id
       token = Phoenix.Token.sign(conn, "auth token", id)
       conn
          |> put_status(:created)
          |> render("token_mobile.json",%{user: authUser, token: token, auth_id: id} )
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
        Accounts.update_auth_id!(auth, user.id)

        conn
          |> fetch_session
          |> put_session(:current_user, user.id)
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
   
  defp convert_error_to_string() do 
     errorAcc = ""
     error = Enum.map  err,  fn {k, v} ->
       errorAcc = errorAcc <>  Kernel.inspect(k) <> " "
       q = Enum.reduce(v, "", fn(x, acc) -> x <> acc end)
       errorAcc <> q
     end
       error = Enum.reduce(error, "", fn(x, acc) -> x <> " and " <> acc end)
       error = String.replace(error, ":", "")
       error = String.slice(error, 0..-6)
  end


  def delete(conn, _params) do
    conn
      |> render("delete_token.json")
  end

end
