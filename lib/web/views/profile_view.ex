defmodule Web.ProfileView do
  use Web, :view

  def full_name(user), do: "#{user.first_name} #{user.last_name}"
end
