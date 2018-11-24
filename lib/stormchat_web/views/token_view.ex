defmodule StormchatWeb.TokenView do
  use StormchatWeb, :view

  def render("token.json", %{user: user, token: token}) do
    %{
      user_id: user.id,
      name: user.name,
      email: user.email,
      location: user.location,
      subscribed: user.subscribed,
      token: token,
    }
  end

  def render("token_mobile.json", %{user: user, token: token, auth_id: auth_id}) do
    %{
      user_id: user.id,
      token: token,
      name: user.name,
      email: user.email,
      location: user.location,
      subscribed: user.subscribed,
      provider: user.provider,
      auth: user.auth,
      auth_id: auth_id,
    }
  end

  def render("delete_token.json", %{}) do
    %{}
  end

  def render("error.json", %{error: error}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{errors: error}
  end

end
