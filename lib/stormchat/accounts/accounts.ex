defmodule Stormchat.Accounts do

  import Ecto.Query, warn: false
  import Ecto.Changeset, only: [put_change: 3]

  alias Stormchat.Repo
  alias Stormchat.Accounts.User
  alias Stormchat.Accounts.AuthUser

  def list_users do
    Repo.all(User)
  end

  def list_by_location_sub(location) do
    Repo.all(from u in User,
          where: u.location == ^location and u.subscribed == :true)
  end

  def get_by_id!(id) do
    Repo.get_by(User, id: id)
  end

  def get_by_email!(email) do
    Repo.get_by(User, email: email)
  end

  def get_authuser_by_email!(email) do
    Repo.get_by(AuthUser, email: email)
  end

  def create_authuser(changeset) do
    Repo.insert(changeset)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> put_change(:crypted_password, hashed_password(attrs["password"]))
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> put_change(:crypted_password, hashed_password(attrs["password"]))
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  defp hashed_password(password) do
     Comeonin.Argon2.hashpwsalt(password)
  end

  def get_and_auth_user(email, pass) do
    user = get_by_email!(String.downcase(email))
    case authenticate(user, pass) do
      true -> {:ok, user}
      _    -> {:error, "Incorrect login details, try again"}
    end
  end

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> Comeonin.Argon2.checkpw(password, user.crypted_password)
    end
  end

end
