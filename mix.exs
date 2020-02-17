defmodule SteinExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :stein_example,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {SteinExample.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bamboo, "~> 1.3"},
      {:credo, "~> 1.1", only: [:dev, :test]},
      {:ecto_sql, "~> 3.1"},
      {:ecto_enum, "~> 1.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:logster, "~> 1.0"},
      {:phoenix, "~> 1.4.11"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_pubsub, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},
      {:porcelain, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      {:stein, "~> 0.5.1"},
      {:stein_phoenix, "~> 0.1"},
      {:stein_mfa, git: "https://github.com/smartlogic/stein_mfa.git", ref: "donald-toplevel"},
      {:stein_storage, git: "https://github.com/smartlogic/stein_storage.git"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "ecto.migrate.reset": ["ecto.drop", "ecto.create", "ecto.migrate"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
