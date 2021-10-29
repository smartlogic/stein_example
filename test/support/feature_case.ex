defmodule SteinExample.FeatureCase do
  @moduledoc """
  Case for Wallaby feature tests
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.Feature

      alias SteinExample.TestHelpers

      import SteinExample.FeatureCase.Helpers
    end
  end
end

defmodule SteinExample.FeatureCase.Helpers do
  @moduledoc false

  import Wallaby.Browser

  alias Wallaby.Query

  @doc """
  Sign in as a user
  """
  def sign_in(session, email, password \\ "password") do
    session
    |> visit("/")
    |> click(Query.link("Sign In"))
    |> fill_in(Query.text_field("Email"), with: email)
    |> fill_in(Query.text_field("Password"), with: password)
    |> click(Query.button("Login"))
    |> assert_has(Query.css(".alert", text: "You have signed in."))
  end
end
