# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :stein_example,
  namespace: Web,
  ecto_repos: [SteinExample.Repo]

# Configures the endpoint
config :stein_example, Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yW/yP/NZJMq20vED3uJQwVzfLC9tElRDtwmmOeIYOnzIb5Dh9jsJk6A41lHZ1HlV",
  render_errors: [view: Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SteinExample.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :stein_phoenix, :views, error_helpers: Web.ErrorHelpers

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
