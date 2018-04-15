defmodule StormchatWeb.PostController do
  use StormchatWeb, :controller

  alias Stormchat.Social
  alias Stormchat.Social.Post

  action_fallback StormchatWeb.FallbackController

  def index(conn, %{"topic" => topic}) do
    posts = Social.list_posts_by_topic(topic)
    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}) do

    conn = fetch_session(conn)
    user_id = conn |> get_session(:current_user) |> Kernel.inspect
    if post_params["user_id"] != user_id do
      IO.inspect({:bad_match, post_params["user_id"], user_id})
      raise "hax!"
    end
    
    with {:ok, %Post{} = post} <- Social.create_post(post_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", post_path(conn, :show, post))
      |> render("show.json", post: post)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Social.get_post!(id)
    render(conn, "show.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Social.get_post!(id)

    with {:ok, %Post{} = post} <- Social.update_post(post, post_params) do
      render(conn, "show.json", post: post)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Social.get_post!(id)
    with {:ok, %Post{}} <- Social.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
