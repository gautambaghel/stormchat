defmodule StormchatWeb.PageController do
  use StormchatWeb, :controller

  alias Stormchat.Accounts.User
  alias Stormchat.Session

  def index(conn, _params) do
    logged_in = Session.logged_in?(conn)
    changeset = User.changeset(%User{})
    locations = [%{name: "Massachusetts", short_form: "MA"}]
    render conn, "index.html", logged_in: logged_in, changeset: changeset, locations: locations
  end
end
