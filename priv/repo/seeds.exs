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

  def run do

    Repo.delete_all(Location)
    Repo.insert!(%Location{ name: "Massachusetts", abb: "MA"})
    Repo.insert!(%Location{ name: "California", abb: "CA"})

  end
end

Seeds.run
