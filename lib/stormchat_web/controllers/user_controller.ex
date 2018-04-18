defmodule StormchatWeb.UserController do
  use StormchatWeb, :controller

  alias Stormchat.Accounts
  alias Stormchat.Accounts.User
  alias Stormchat.Locations
  alias Stormchat.Session

  action_fallback StormchatWeb.FallbackController

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    locations = Locations.list_locations
    render conn, changeset: changeset, locations: locations
  end

  def index(conn, _params) do
    logged_in = Session.logged_in?(conn)

    case logged_in do
       false ->
         conn
          |> put_flash(:error, "You need to log in first!")
          |> redirect(to: "/")

       true ->
         user_id = conn |> get_session(:current_user)
         user = Accounts.get_by_id!(user_id)
         locations = Locations.list_locations
         changeset = Accounts.change_user(user)
         render(conn, "edit.html", user: user, changeset: changeset, locations: locations)
    end
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

  def update(conn, %{"id" => id, "user" => user_params}) do
  user = Accounts.get_by_id!(id)

  case Accounts.update_user(user, user_params) do
    {:ok, user} ->
      conn
      |> put_flash(:info, ["Your account was updated successfully", " ", user.name])
      |> redirect(to: page_path(conn, :index))
    {:error, %Ecto.Changeset{} = changeset} ->
      render(conn, "edit.html", user: user, changeset: changeset)
  end
end

end
