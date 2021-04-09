import Config

config :stein_example, SteinExample.Repo, ssl: System.get_env("DATABASE_SSL") == "true"

config :stein_example, Web.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true

config :stein_example, SteinExample.Mailer, adapter: Bamboo.LocalAdapter

config :logger, level: :info

config :phoenix, :logger, false

config :stein_phoenix, :views, error_helpers: Web.ErrorHelpers
