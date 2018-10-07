defmodule Stormchat.Repo.Migrations.CreateAuthUser do
  use Ecto.Migration

  def change do
    create table(:auth_user) do
      add :email, :string
      add :auth, :string
      add :auth_id, :string
      add :provider, :string
      add :name, :string
      add :location, :string
      add :subscribed, :boolean, default: false, null: false

      timestamps()
    end

  end
end
