defmodule Stormchat.Social.Post do
  use Ecto.Schema
  import Ecto.Changeset


  schema "posts" do
    field :alert, :string
    field :body, :string
    belongs_to :user, Stormchat.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :alert, :user_id])
    |> validate_required([:body, :alert, :user_id])
  end
end
