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

  def get_auth_user!(auth, provider, name) do
    user = Repo.get_by(AuthUser, auth: auth)
    case user do
      nil -> case Repo.insert %AuthUser{auth: auth, provider: provider, name: name} do
                {:ok, struct}       -> {:ok, struct}
                {:error, changeset} -> {:error, changeset}
             end
      _   -> {:ok, user}
    end
  end

  def add_or_get(changeset, email) do
    user = Repo.get_by(User, email: email)
    case user do
      nil -> case Repo.insert changeset do
                {:ok, struct}       -> {:ok, struct}
                {:error, changeset} -> {:error, changeset}
             end
      _   -> {:ok, user}
    end
  end

  def update_auth_id!(auth, id) do
    user = Repo.get_by(AuthUser, auth: auth)
    user = Ecto.Changeset.change user, auth_id: Kernel.inspect(id)
    case Repo.update user do
      {:ok, struct}       -> {:ok, struct}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def add_authuser_data!(auth, email, location, subscribed) do
    user = Repo.get_by(AuthUser, auth: auth)
    user = Ecto.Changeset.change user, email: email, location: location, subscribed: get_bool_from_str(subscribed)
    case Repo.update user do
      {:ok, struct}       -> {:ok, struct}
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp get_bool_from_str(subscribed) do
    case subscribed do
      "true" -> :true
      _ -> :false
    end
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
