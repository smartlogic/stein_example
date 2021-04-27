defmodule Web.Admin.DashboardController do
  use Web, :controller

  alias SteinExample.Users

  plug(Web.Plugs.SetActiveTab, tab: :dashboard)

  def index(conn, _params) do
    conn
    |> assign(:user_count, Users.count())
    |> render("index.html")
  end
end
