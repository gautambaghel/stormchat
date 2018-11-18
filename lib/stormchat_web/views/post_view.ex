defmodule StormchatWeb.PostView do
  use StormchatWeb, :view
  alias StormchatWeb.PostView

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{id: post.id,
      body: post.body,
      username: post.user.name,
      time: post.inserted_at,
      alert: post.alert}
  end

  def render("error.json", %{msg: msg}) do
      %{msg: msg}
  end

end
