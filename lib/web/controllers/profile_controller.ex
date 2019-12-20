defmodule Web.ProfileController do
  use Web, :controller

  alias SteinExample.Users

  def show(conn, _params) do
    %{current_user: user} = conn.assigns

    conn
    |> assign(:user, user)
    |> render("show.html")
  end

  def edit(conn, _params) do
    %{current_user: user} = conn.assigns

    conn
    |> assign(:user, user)
    |> assign(:changeset, Users.edit(user))
    |> render("edit.html")
  end

  def update(conn, %{"user" => params}) do
    %{current_user: user} = conn.assigns

    case Users.update(user, params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Profile updated")
        |> redirect(to: Routes.profile_path(conn, :show))

      {:error, changeset} ->
        conn
        |> assign(:user, user)
        |> assign(:changeset, changeset)
        |> put_status(422)
        |> render("edit.html")
    end
  end
end
