defmodule Stormchat.Accounts do

  import Ecto.Query, warn: false
  import Ecto.Changeset, only: [put_change: 3]

  alias Stormchat.Repo

  alias Stormchat.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_by_id!(id) do
    Repo.get_by(User, id: id)
  end

  def get_by_email!(email) do
    Repo.get_by(User, email: email)
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

end
