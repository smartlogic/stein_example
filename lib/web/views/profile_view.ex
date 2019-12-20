defmodule Web.ProfileView do
  use Web, :view

  alias Stein.Phoenix.Views.FormView

  def full_name(user), do: "#{user.first_name} #{user.last_name}"
end
