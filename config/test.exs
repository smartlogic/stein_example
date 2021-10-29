use Mix.Config

#
# If you're looking to update variables, you probably want to:
# - Edit `.env.test`
# - Add to `SteinExample.Config` for loading through Vapor
#

config :stein_example, SteinExample.Repo, pool: Ecto.Adapters.SQL.Sandbox

config :stein_example, Web.Endpoint, server: true

config :stein_example, SteinExample.Mailer, adapter: Bamboo.TestAdapter

config :stein_example, SteinExample.PromEx, metrics_server: :disabled

config :stein_example, :sandbox, Ecto.Adapters.SQL.Sandbox

# Print only warnings and errors during test
config :logger, level: :warn

config :bcrypt_elixir, :log_rounds, 4

config :stein_storage, backend: :test

config :wallaby, otp_app: :stein_example

if File.exists?("config/test.extra.exs") do
  import_config("test.extra.exs")
end
