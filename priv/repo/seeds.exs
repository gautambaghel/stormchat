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
    Repo.insert!(%Location{ name: "Alabama", abb: "AL"})
    Repo.insert!(%Location{ name: "Alaska", abb: "AK"})
    Repo.insert!(%Location{ name: "Arizona", abb: "AZ"})
    Repo.insert!(%Location{ name: "Arkansas", abb: "AR"})
    Repo.insert!(%Location{ name: "California", abb: "CA"})
    Repo.insert!(%Location{ name: "Colorado", abb: "CO"})
    Repo.insert!(%Location{ name: "Connecticut", abb: "CT"})
    Repo.insert!(%Location{ name: "Delaware", abb: "DE"})
    Repo.insert!(%Location{ name: "Florida", abb: "FL"})
    Repo.insert!(%Location{ name: "Georgia", abb: "GA"})
    Repo.insert!(%Location{ name: "Hawaii", abb: "HI"})
    Repo.insert!(%Location{ name: "Idaho", abb: "ID"})
    Repo.insert!(%Location{ name: "Illinois", abb: "IL"})
    Repo.insert!(%Location{ name: "Indiana", abb: "IN"})
    Repo.insert!(%Location{ name: "Iowa", abb: "IA"})
    Repo.insert!(%Location{ name: "Kansas", abb: "KS"})
    Repo.insert!(%Location{ name: "Kentucky", abb: "KY"})
    Repo.insert!(%Location{ name: "Louisiana", abb: "LA"})
    Repo.insert!(%Location{ name: "Maine", abb: "ME"})
    Repo.insert!(%Location{ name: "Maryland", abb: "MD"})
    Repo.insert!(%Location{ name: "Massachusetts", abb: "MA"})
    Repo.insert!(%Location{ name: "Michigan", abb: "MI"})
    Repo.insert!(%Location{ name: "Minnesota", abb: "MN"})
    Repo.insert!(%Location{ name: "Mississippi", abb: "MS"})
    Repo.insert!(%Location{ name: "Missouri", abb: "MO"})
    Repo.insert!(%Location{ name: "Montana", abb: "MT"})
    Repo.insert!(%Location{ name: "Nebraska", abb: "NE"})
    Repo.insert!(%Location{ name: "Nevada", abb: "NV"})
    Repo.insert!(%Location{ name: "New Hampshire", abb: "NH"})
    Repo.insert!(%Location{ name: "New Jersey", abb: "NJ"})
    Repo.insert!(%Location{ name: "New Mexico", abb: "NM"})
    Repo.insert!(%Location{ name: "New York", abb: "NY"})
    Repo.insert!(%Location{ name: "North Carolina", abb: "NC"})
    Repo.insert!(%Location{ name: "North Dakota", abb: "ND"})
    Repo.insert!(%Location{ name: "Ohio", abb: "OH"})
    Repo.insert!(%Location{ name: "Oklahoma", abb: "OK"})
    Repo.insert!(%Location{ name: "Oregon", abb: "OR"})
    Repo.insert!(%Location{ name: "Pennsylvania", abb: "PA"})
    Repo.insert!(%Location{ name: "Rhode Island", abb: "RI"})
    Repo.insert!(%Location{ name: "South Carolina", abb: "SC"})
    Repo.insert!(%Location{ name: "South Dakota", abb: "SD"})
    Repo.insert!(%Location{ name: "Tennessee", abb: "TN"})
    Repo.insert!(%Location{ name: "Texas", abb: "TX"})
    Repo.insert!(%Location{ name: "Utah", abb: "UT"})
    Repo.insert!(%Location{ name: "Vermont", abb: "VT"})
    Repo.insert!(%Location{ name: "Virginia", abb: "VA"})
    Repo.insert!(%Location{ name: "Washington", abb: "WA"})
    Repo.insert!(%Location{ name: "West Virginia", abb: "WV"})
    Repo.insert!(%Location{ name: "Wisconsin", abb: "WI"})
    Repo.insert!(%Location{ name: "Wyoming", abb: "WY"})

    Repo.delete_all(User)
    a = Repo.insert!(%User{ email: "dave@gmail.com", name: "dave", crypted_password: p, location: "MA", subscribed: true})
    b = Repo.insert!(%User{ email: "bob@gmail.com", name: "bob", crypted_password: p, location: "MA" })

    Repo.delete_all(Post)
    Repo.insert!(%Post{ alert: "NWS-IDP-PROD-2768387-2582650", body: "Any one need help?", user: a })
    Repo.insert!(%Post{ alert: "NWS-IDP-PROD-2768387-2582650", body: "Yeah, stuck here!", user: b })

  end
end

Seeds.run
