defmodule Web.ProfileController do
  use Web, :controller

  def show(conn, _params) do
    %{current_user: user} = conn.assigns

    conn
    |> assign(:user, user)
    |> render("show.html")
  end
end
