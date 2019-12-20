defmodule SteinExample.UsersTest do
  use SteinExample.DataCase
  use Bamboo.Test

  alias SteinExample.Users

  describe "creating new users" do
    test "registers them" do
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

  describe "updating users" do
    test "change basic info" do
      {:ok, user} = TestHelpers.create_user()

      {:ok, user} =
        Users.update(user, %{
          first_name: "Updated",
          last_name: "LastName"
        })

      assert user.first_name == "Updated"
      assert user.last_name == "LastName"
    end

    test "changing email triggers verification" do
      {:ok, user} = TestHelpers.create_user()
      {:ok, user} = Users.verify_email(user.email_verification_token)

      {:ok, user} =
        Users.update(user, %{
          email: "new@example.com"
        })

      assert user.email == "new@example.com"
      assert user.email_verification_token
      refute user.email_verified_at
    end
  end

  describe "password resets" do
    test "starting a password reset" do
      {:ok, user} = TestHelpers.create_user(%{email: "user@example.com"})

      :ok = Users.start_password_reset(user.email)

      assert_email_delivered_with(to: [nil: "user@example.com"])
    end
  end
end
