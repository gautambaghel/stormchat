
def create(conn, %{"user" => user_params}) do
  user = Repo.get_by(User, email: user_params["email"])
  cond do
    user && checkpw(user_params["password"], user.password_hash) ->
      session_changeset = Stormchat.Session.create_changeset(%Stormchat.Session{}, %{user_id: user.id})
      {:ok, session} = Repo.insert(session_changeset)
      conn
        |> put_status(:created)
        |> render("show.json", session: session)
      user ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", user_params)
      true ->
        dummy_checkpw
        conn
        |> put_status(:unauthorized)
        |> render("error.json", user_params)
    end
  end
