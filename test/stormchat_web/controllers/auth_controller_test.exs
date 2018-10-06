defmodule Stormchat.AuthControllerTest do
  use StormchatWeb.ConnCase

  alias Stormchat.Accounts.User
  alias Stormchat.Repo

  @ueberauth_auth %{credentials: %{token: "fdsnoafhnoofh08h38h"},
                    info: %{email: "batman@example.com", first_name: "Bruce", last_name: "Wayne"},
                    provider: :google}

  # Add the below test
  test "creates user from Google information", %{conn: conn} do
    conn = conn
    |> assign(:ueberauth_auth, @ueberauth_auth)
    |> get("/auth/google/callback")

    users = User |> Repo.all
    assert Enum.count(users) == 1
    assert get_flash(conn, :info) == "Thank you for signing in!"
  end
end
