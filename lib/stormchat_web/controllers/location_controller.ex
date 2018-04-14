defmodule StormchatWeb.LocationController do
  use StormchatWeb, :controller

  alias Stormchat.Locations
  alias Stormchat.Locations.Location

  def index(conn, _params) do
    locations = Locations.list_locations()
    render(conn, "index.html", locations: locations)
  end

end
