defmodule StormchatWeb.PageController do
  use StormchatWeb, :controller

  alias Stormchat.Accounts
  alias Stormchat.Accounts.User

  alias Stormchat.Session
  alias Stormchat.Locations

  alias Stormchat.CallAPI

  action_fallback StormchatWeb.FallbackController

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
          data = CallAPI.get_data_from_external_server(user.location)
          render conn, "index.html", user: user, location: location, alerts: data
        end
      end

      def chat(conn, %{"id" => id}) do

        logged_in = Session.logged_in?(conn)

        case logged_in do
          false ->
            changeset = User.changeset(%User{})
            locations = Locations.list_locations
            render conn, "index_not_logged.html", changeset: changeset, locations: locations

          true ->
            data = CallAPI.get_data_for_id(id)

            severity = data["severity"]
            category = data["category"]
            certainty = data["certainty"]
            response = data["response"]
            instruction = data["instruction"]
            event = data["event"]
            areaDesc = data["areaDesc"]

            user_id = conn |> get_session(:current_user)
            render conn, "chat.html", alert_id: id, severity: severity,
            user_id: user_id, category: category, certainty: certainty,
            response: response, instruction: instruction, event: event,
            areaDesc: areaDesc
         end
       end

    end
