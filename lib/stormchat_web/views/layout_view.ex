defmodule StormchatWeb.LayoutView do
  import Stormchat.Session, only: [current_user: 1, logged_in?: 1]
  use StormchatWeb, :view
end
