import Config

config :stein_example, SteinExample.Repo, ssl: System.get_env("DATABASE_SSL") == "true"

config :stein_example, Web.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true

config :stein_example, SteinExample.Mailer, adapter: Bamboo.LocalAdapter

config :logger, level: :info

config :phoenix, :logger, false

config :stein_phoenix, :views, error_helpers: Web.ErrorHelpers

release =
  case File.exists?("REVISION") do
    true ->
      String.trim(File.read!("REVISION"))

    false ->
      "unknown"
  end

config :sentry,
  dsn: System.get_env("SENTRY_DSN_URL"),
  environment_name: System.get_env("DEPLOY_ENV"),
  release: revision,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  included_environments: ["production", "staging"]
