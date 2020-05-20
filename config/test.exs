use Mix.Config

#
# If you're looking to update variables, you probably want to:
# - Edit `.env.test`
# - Add to `SteinExample.Config` for loading through Vapor
#

# Configure your database
config :stein_example, SteinExample.Repo, pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :stein_example, Web.Endpoint,
  http: [port: 4002],
  server: false

config :stein_example, SteinExample.Mailer, adapter: Bamboo.TestAdapter

# Print only warnings and errors during test
config :logger, level: :warn

config :bcrypt_elixir, :log_rounds, 4

config :stein_storage, backend: :test

if File.exists?("config/test.extra.exs") do
  import_config("test.extra.exs")
end
