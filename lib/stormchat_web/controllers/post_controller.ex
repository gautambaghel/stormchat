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
    user_id = conn |> fetch_session |> get_session(:current_user) |> Kernel.inspect
    cond do
      post_params["user_id"] != user_id ->
        IO.inspect({:bad_match, post_params["user_id"], user_id})
        conn |> render("error.json", msg: "Hax!")
      true ->
        with {:ok, %Post{} = post} <- Social.create_post(post_params) do
          post = Social.get_post!(post.id)
          topic = post.alert
          conn
          |> put_status(:created)
          |> put_resp_header("location", post_path(conn, :show, topic, post))
          |> render("show.json", post: post)
        end
    end
  end

  def mobile(conn, %{"token" => token, "post" => post_params}) do
    case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
      {:ok, user_id} ->
            cond do
              post_params["user_id"] != Kernel.inspect(user_id) ->
                IO.inspect({:bad_match, post_params["user_id"], user_id})
                conn |> render("error.json", msg: "Hax!")
              true ->
                with {:ok, %Post{} = post} <- Social.create_post(post_params) do
                  post = Social.get_post!(post.id)
                  topic = post.alert
                  conn
                  |> put_status(:created)
                  |> put_resp_header("location", post_path(conn, :show, topic, post))
                  |> render("show.json", post: post)
                end
            end
      {:error, err} ->
            conn |> render("error.json", msg: err)
     end
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
