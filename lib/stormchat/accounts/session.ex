defmodule Stormchat.Session do
  
  alias Stormchat.Accounts

  def login(params) do
    user = Accounts.get_by_email!(String.downcase(params["email"]))
    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  def current_user(conn) do
    id = Plug.Conn.get_session(conn, :current_user)
    if id, do: Accounts.get_by_id!(id)
  end

  def logged_in?(conn), do: !!current_user(conn)

  defp authenticate(user, password) do
    IO.inspect user
    IO.inspect password
    case user do
      nil -> false
      _   -> Comeonin.Argon2.checkpw(password, user.crypted_password)
    end
  end
end
