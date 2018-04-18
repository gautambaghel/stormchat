defmodule Stormchat.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string,  null: false, unique: true
      add :crypted_password, :string,  null: false
      add :name, :string,  null: false
      add :location, :string,  null: false
      add :subscribed, :boolean,  default: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
