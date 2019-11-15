defmodule SteinExample.Emails do
  @moduledoc false

  use Bamboo.Phoenix, view: SteinExample.Emails.EmailView

  alias Web.Endpoint
  alias Web.Router.Helpers, as: Routes

  def welcome_email(user) do
    confirm_url = Routes.confirmation_url(Endpoint, :confirm, code: user.email_verification_token)

    base_email()
    |> to(user.email)
    |> subject("Welcome to Stein!")
    |> assign(:confirm_url, confirm_url)
    |> render(:welcome)
  end

  defp base_email() do
    new_email()
    |> from("no-reply@example.com")
  end

  defmodule EmailView do
    @moduledoc false

    use Phoenix.View, root: "lib/stein_example/emails/templates", path: ""
    use Phoenix.HTML
  end
end
