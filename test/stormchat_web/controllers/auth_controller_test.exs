defmodule Stormchat.AuthControllerTest do
  use StormchatWeb.ConnCase

  alias Stormchat.Accounts.AuthUser
  alias Stormchat.Repo

  @ueberauth_auth_g %{credentials: %{token: "fdsnoafhnoofh08h38h"},
                    info: %{email: "batman@example.com", first_name: "Bruce", last_name: "Wayne", location: "MA"},
                    provider: "google"}

  @ueberauth_auth_f %{credentials: %{token: "fdsnoasdafhasdnoofh08h38h"},
                    info: %{email: "superman@example.com", first_name: "Clark", last_name: "Kent", location: "NY"},
                    provider: "facebook"}

  # Add the below test
  test "creates user from Google information", %{conn: conn} do
    conn
    |> assign(:ueberauth_auth, @ueberauth_auth_g)
    |> get("/auth/google/callback")

    users = AuthUser |> Repo.all
    assert Enum.count(users) == 1
  end

  test "creates user from Facebook information", %{conn: conn} do
    conn
    |> assign(:ueberauth_auth, @ueberauth_auth_f)
    |> get("/auth/facebook/callback")

    users = AuthUser |> Repo.all
    assert Enum.count(users) == 1
  end

end
