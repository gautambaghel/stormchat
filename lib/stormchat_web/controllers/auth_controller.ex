defmodule StormchatWeb.AuthController do
  use StormchatWeb, :controller
  plug Ueberauth

  alias Stormchat.Accounts
  alias Stormchat.Accounts.AuthUser

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    auth_user_params = %{auth: auth.credentials.token,
                         name: auth.info.first_name,
                         location: auth.info.location,
                         email: auth.info.email,
                         provider: auth.provider}
    changeset = AuthUser.changeset(%AuthUser{}, auth_user_params)
    insert_or_update_user(conn, changeset)
    conn
  end

  # def create(conn, changeset) do
  #   case insert_or_update_user(changeset) do
  #     {:ok, user} ->
  #       conn
  #       |> put_flash(:info, "Thank you for signing in!")
  #       |> put_session(:user_id, user.id)
  #       |> redirect(to: page_path(conn, :index))
  #     {:error, _reason} ->
  #       conn
  #       |> put_flash(:error, "Error signing in")
  #       |> redirect(to: page_path(conn, :index))
  #   end
  # end

  def delete(conn, _params) do
    conn
      |> render("delete_token.json")
  end

  defp insert_or_update_user(conn, changeset) do
    case Accounts.get_authuser_by_email!(changeset.changes.email) do
      nil ->
        {:ok, user} = Accounts.create_authuser(changeset)
        conn |> add_user_token(user)
      user ->
        conn |> add_user_token(user)
    end
  end

  defp add_user_token(conn, user) do
    token = Phoenix.Token.sign(conn, "auth token", user.id)
    conn
      |> put_status(:created)
      |> render("token.json", user: user, token: token)

    {:ok, user}
  end

end
