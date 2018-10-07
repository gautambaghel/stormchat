defmodule Stormchat.Accounts.AuthUser do
  use Ecto.Schema
  import Ecto.Changeset


  schema "auth_user" do
    field :email, :string
    field :auth, :string
    field :auth_id, :string
    field :provider, :string
    field :name, :string
    field :location, :string
    field :subscribed, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(auth_user, attrs) do
    auth_user
    |> cast(attrs, [:email, :auth, :auth_id, :provider, :name, :location, :subscribed])
    |> validate_required([:auth, :provider])
  end
end
