defmodule Web.Admin.UserController do
  use Web, :controller

  alias SteinExample.Users
  alias Web.Router.Helpers, as: Routes

  plug(Web.Plugs.SetActiveTab, tab: :users)
  plug(Web.Plugs.FetchPage when action in [:index])

  def index(conn, _params) do
    %{page: page, per: per} = conn.assigns
    %{page: users, pagination: pagination} = Users.all(page: page, per: per)

    conn
    |> assign(:path, Routes.admin_user_path(conn, :index))
    |> assign(:users, users)
    |> assign(:pagination, pagination)
    |> render("index.html")
  end

  def show(conn, %{"id" => id}) do
    with {:ok, user} <- Users.get(id) do
      conn
      |> assign(:user, user)
      |> render("show.html")
    end
  end
end
