defmodule Web.MFAController do
  use Web, :controller

  alias SteinExample.Users

  def index(conn, _params) do
    %{current_user: user} = conn.assign
  end
end
