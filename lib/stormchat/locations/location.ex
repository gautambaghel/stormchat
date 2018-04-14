defmodule Stormchat.Locations.Location do
  use Ecto.Schema
  import Ecto.Changeset


  schema "locations" do
    field :abb, :string
    field :name, :string
    field :data, :string

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name, :abb, :data])
    |> validate_required([:name, :abb])
  end
end
