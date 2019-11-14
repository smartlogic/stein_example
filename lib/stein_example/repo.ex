defmodule SteinExample.Repo do
  use Ecto.Repo,
    otp_app: :stein_example,
    adapter: Ecto.Adapters.Postgres
end
