defmodule StormchatWeb.PageController do
  use StormchatWeb, :controller

  alias Stormchat.Accounts
  alias Stormchat.Accounts.User

  alias Stormchat.Session
  alias Stormchat.Locations

  alias Stormchat.CallAPI

  def index(conn, _params) do
    logged_in = Session.logged_in?(conn)

    case logged_in do
       false ->
         changeset = User.changeset(%User{})
         locations = Locations.list_locations
         render conn, "index_not_logged.html", changeset: changeset, locations: locations

       true ->
         user_id = conn |> get_session(:current_user)
         user = Accounts.get_by_id!(user_id)
         location = Locations.get_by_abbr!(user.location).name

         {:ok, pid} = CallAPI.start_link
         {_, data} = CallAPI.get_weather(pid, user.location)
         data = Poison.decode!(data)
         data = data["features"]
         render conn, "index.html", user: user, location: location, alerts: data
    end
  end

  def chat(conn, %{"id" => id, "properties" => properties}) do
        render conn, "chat.html", id: id, alert: properties
  end

end
