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

          {:ok, pid} = CallAPI.start_link([])
          data = CallAPI.get_weather(pid, user.location)

          dataMap = Enum.reduce data, %{}, fn x, acc ->
            Map.put(acc, x["properties"]["id"], x["properties"])
          end

          render conn, "index.html", user: user, location: location, alerts: dataMap
        end
      end

      def chat(conn, %{"id" => id, "severity" => severity,
      "category" => category, "certainty" => certainty,
      "response" => response, "instruction" => instruction,
      "event" => event, "areaDesc" => areaDesc}) do

        user_id = conn |> get_session(:current_user)
        render conn, "chat.html", alert_id: id, severity: severity,
        user_id: user_id, category: category, certainty: certainty,
        response: response, instruction: instruction, event: event,
        areaDesc: areaDesc
      end

    end
