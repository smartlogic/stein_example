defmodule SteinExample.Features.RegistrationTest do
  use SteinExample.FeatureCase, async: true

  feature "signing in as a user", %{session: session} do
    session
    |> visit("/")
    |> click(Query.link("Register"))
    |> fill_in(Query.text_field("Email"), with: "user@example.com")
    |> fill_in(Query.text_field("First name"), with: "User")
    |> fill_in(Query.text_field("Last name"), with: "Example")
    |> fill_in(Query.css("#user_password"), with: "password")
    |> fill_in(Query.css("#user_password_confirmation"), with: "password")
    |> click(Query.button("Register"))
    |> assert_has(Query.css(".alert", text: "Welcome to"))
  end
end
