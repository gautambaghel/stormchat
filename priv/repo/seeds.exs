# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Stormchat.Repo.insert!(%Stormchat.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


defmodule Seeds do

  alias Stormchat.Repo
  alias Stormchat.Locations.Location
  alias Stormchat.Accounts.User
  alias Stormchat.Social.Post

  def run do

    p = Comeonin.Argon2.hashpwsalt("password1")

    Repo.delete_all(Location)
    Repo.insert!(%Location{ name: "Massachusetts", abb: "MA"})
    Repo.insert!(%Location{ name: "California", abb: "CA"})
    Repo.insert!(%Location{ name: "New York", abb: "NY"})

    Repo.delete_all(User)
    a = Repo.insert!(%User{ email: "dave@gmail.com", name: "dave", crypted_password: p, location: "MA" })
    b = Repo.insert!(%User{ email: "bob@gmail.com", name: "bob", crypted_password: p, location: "MA" })

    Repo.delete_all(Post)
    Repo.insert!(%Post{ alert: "nws123", body: "Any one need help?", user: a })
    Repo.insert!(%Post{ alert: "nws123", body: "Yeah, stuck here!", user: b })

  end
end

Seeds.run
