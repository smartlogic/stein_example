import Config

config :logger, level: :info, backends: [:console, Sentry.LoggerBackend]
