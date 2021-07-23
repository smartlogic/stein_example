# Loosely from https://github.com/bitwalker/distillery/blob/master/docs/Running%20Migrations.md
defmodule SteinExample.ReleaseTasks do
  @moduledoc false

  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto,
    :ecto_sql
  ]

  @start_extra_apps [
    :gettext,
    :ranch
  ]

  @repos [
    SteinExample.Repo
  ]

  def startup() do
    IO.puts("Loading stein_example...")

    # Load the code for stein_example, but don't start it
    Application.load(:stein_example)

    IO.puts("Starting dependencies..")
    # Start apps necessary for executing migrations
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    # Start the Repo(s) for stein_example
    IO.puts("Starting repos..")
    Enum.each(@repos, & &1.start_link(pool_size: 2))
  end

  def startup_extra() do
    Enum.each(@start_extra_apps, &Application.ensure_all_started/1)
    start(Web.Endpoint.start_link())
    start(SteinExample.Config.Cache.start_link([]))
  end

  defp start({:ok, _pid}), do: :ok

  defp start({:error, {:already_started, _pid}}), do: :ok
end

defmodule SteinExample.ReleaseTasks.Migrate do
  @moduledoc """
  Migrate the database
  """

  alias SteinExample.ReleaseTasks
  alias SteinExample.Repo

  @apps [
    :stein_example
  ]

  @doc """
  Migrate the database
  """
  def run() do
    ReleaseTasks.startup()
    Enum.each(@apps, &run_migrations_for/1)
    IO.puts("Success!")
  end

  def priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp run_migrations_for(app) do
    IO.puts("Running migrations for #{app}")
    Ecto.Migrator.run(Repo, migrations_path(app), :up, all: true)
  end

  defp migrations_path(app), do: Path.join([priv_dir(app), "repo", "migrations"])
end

defmodule SteinExample.ReleaseTasks.Seeds do
  @moduledoc """
  Seed the database

  NOTE: This should only be used in the docker compose or staging environments
  """

  alias SteinExample.ReleaseTasks

  @apps [
    :stein_example
  ]

  @doc """
  Migrate the database
  """
  def run() do
    ReleaseTasks.startup()
    ReleaseTasks.startup_extra()
    Enum.each(@apps, &run_seeds_for/1)
    IO.puts("Success!")
  end

  def priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp run_seeds_for(app) do
    # Run the seed script if it exists
    seed_script = seeds_path(app)

    if File.exists?(seed_script) do
      IO.puts("Running seed script..")
      Code.eval_file(seed_script)
    end
  end

  defp seeds_path(app), do: Path.join([priv_dir(app), "repo", "seeds.exs"])
end
