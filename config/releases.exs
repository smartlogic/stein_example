import Config

config :stein_example, SteinExample.Repo,
  ssl: true,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :stein_example, Web.Endpoint,
  http: [port: String.to_integer(System.get_env("PORT"))],
  url: [host: System.get_env("HOST"), port: 443, scheme: "https"],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true

config :stein_example, SteinExample.Mailer, adapter: Bamboo.LocalAdapter

config :logger, level: :info

config :phoenix, :logger, false

config :stein_phoenix, :views, error_helpers: Web.ErrorHelpers
