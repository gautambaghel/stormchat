defmodule StormchatWeb.PageView do
  use StormchatWeb, :view
  
  def render("index.json", %{alerts: alerts}) do
    alerts
  end

  def render("error.json", %{msg: msg}) do
      %{error: msg}
  end

end
