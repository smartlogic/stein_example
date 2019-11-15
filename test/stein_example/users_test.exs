defmodule SteinExample.UsersTest do
  use SteinExample.DataCase

  alias SteinExample.Users

  describe "inviting new users" do
    test "starts the invitation process" do
      {:ok, user} =
        Users.create(%{
          email: "user@example.com",
          first_name: "John",
          last_name: "User",
          password: "password",
          password_confirmation: "password"
        })

      assert user.email == "user@example.com"
      assert user.first_name == "John"
      assert user.last_name == "User"
    end
  end
end
