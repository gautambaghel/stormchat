defmodule StormchatWeb.UserController do
  use StormchatWeb, :controller

  alias Stormchat.Accounts
  alias Stormchat.Accounts.User

  action_fallback StormchatWeb.FallbackController

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    locations = [%{name: "Massachusetts", short_form: "MA"}]
    render conn, changeset: changeset, locations: locations
  end


  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
         conn
          |> put_session(:current_user, user.id)
          |> put_flash(:info, ["Your account was created", " ", user.name])
          |> redirect(to: "/")
      {:error, changeset} ->conn
          |> put_flash(:info, "Unable to create account")
          |> render("new.html", changeset: changeset)
    end
  end

end
