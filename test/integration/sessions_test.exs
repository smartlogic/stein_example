defmodule SteinExample.Features.SessionsTest do
  use SteinExample.FeatureCase, async: true

  feature "signing in as a user", %{session: session} do
    {:ok, _user} = TestHelpers.create_user(%{email: "user@example.com"})

    session
    |> visit("/")
    |> click(Query.link("Sign In"))
    |> fill_in(Query.text_field("Email"), with: "user@example.com")
    |> fill_in(Query.text_field("Password"), with: "password")
    |> click(Query.button("Login"))
    |> assert_has(Query.css(".alert", text: "You have signed in."))
    |> click(Query.link("Sign Out"))
    |> assert_has(Query.css(".alert", text: "You have signed out."))
  end
end
