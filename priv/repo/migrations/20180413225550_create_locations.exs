defmodule Stormchat.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :name, :string
      add :abb, :string
      add :data, :string

      timestamps()
    end

  end
end
