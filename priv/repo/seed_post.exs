defmodule Seeds do

  alias Stormchat.Repo
  alias Stormchat.Accounts.User
  alias Stormchat.Social.Post

  def run do

    a = Repo.get_by(User, email: "dave@gmail.com")
    Repo.insert! %Post{ alert: "NWS-IDP-PROD-2771437-2584995", body: "asdasd", user: a }

  end
end

Seeds.run
