defmodule SteinExample.PromEx do
  @moduledoc false

  use PromEx, otp_app: :stein_example

  alias PromEx.Plugins
  alias SteinExample.Config

  @doc """
  Override the init opts to configure more dynamically
  """
  def init_opts() do
    config = Application.get_env(:stein_example, __MODULE__, [])
    grafana_config = Config.grafana()

    case !is_nil(grafana_config.host) do
      true ->
        grafana_config = Enum.into(grafana_config, [])
        PromEx.Config.build([{:grafana, grafana_config} | config])

      false ->
        PromEx.Config.build(config)
    end
  end

  @impl true
  def plugins() do
    [
      {Plugins.Application,
       metric_prefix: [:prom_ex, :application],
       git_sha_mfa: {__MODULE__, :git_shim, []},
       git_author_mfa: {__MODULE__, :git_shim, []}},
      {Plugins.Beam, metric_prefix: [:prom_ex, :beam]},
      {Plugins.Phoenix, metric_prefix: [:prom_ex, :phoenix], router: Web.Router},
      {Plugins.Ecto, metric_prefix: [:prom_ex, :ecto]},
      # {Plugins.Oban, metric_prefix: [:prom_ex, :oban], oban_supervisors: [Oban]},
      {Plugins.PromEx, metric_prefix: [:prom_ex, :prom_ex]}
    ]
  end

  def git_shim(), do: nil

  @impl true
  def dashboard_assigns() do
    [
      datasource_id: Config.grafana_datasource_id(),
      application_metric_prefix: "prom_ex_application",
      beam_metric_prefix: "prom_ex_beam",
      phoenix_metric_prefix: "prom_ex_phoenix",
      ecto_metric_prefix: "prom_ex_ecto",
      oban_metric_prefix: "prom_ex_oban",
      prom_ex_metric_prefix: "prom_ex_prom_ex"
    ]
  end

  @impl true
  def dashboards() do
    [
      {:prom_ex, "application.json"},
      {:prom_ex, "beam.json"},
      {:prom_ex, "phoenix.json"},
      {:prom_ex, "ecto.json"},
      {:prom_ex, "oban.json"}
    ]
  end
end
