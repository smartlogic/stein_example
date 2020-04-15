defmodule SteinExample.Repo do
  use Ecto.Repo,
    otp_app: :stein_example,
    adapter: Ecto.Adapters.Postgres

  alias Vapor.Provider.Dotenv
  alias Vapor.Provider.Env

  def init(_type, config) do
    providers = [
      %Dotenv{},
      %Env{bindings: [database_url: "DATABASE_URL", pool_size: "POOL_SIZE"]}
    ]

    translations = [
      pool_size: fn s -> String.to_integer(s) end
    ]

    vapor_config = Vapor.load!(providers, translations)

    config =
      Keyword.merge(config,
        url: vapor_config.database_url,
        pool_size: vapor_config.pool_size
      )

    {:ok, config}
  end
end
