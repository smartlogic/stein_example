defmodule SteinExample.Telemetry do
  @moduledoc false

  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    children = [
      SteinExample.Telemetry.Reporters
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

defmodule SteinExample.Telemetry.Reporters do
  @moduledoc """
  GenServer to hook up telemetry events on boot

  Attaches reporters after initialization
  """

  use GenServer

  alias SteinExample.ObanReporter

  def start_link(opts) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init(_) do
    {:ok, %{}, {:continue, :initialize}}
  end

  def handle_continue(:initialize, state) do
    reporters = [
      ObanReporter
    ]

    Enum.each(reporters, fn reporter ->
      :telemetry.attach_many(reporter, reporter.events(), &reporter.handle_event/4, [])
    end)

    {:noreply, state}
  end
end

defmodule SteinExample.ObanReporter do
  @moduledoc """
  Report on Oban events

  Print locally any exceptions that happen to see in the console log.
  """

  require Logger

  def events() do
    [
      [:oban, :job, :exception]
    ]
  end

  def handle_event([:oban, :job, :exception], _measure, meta, _) do
    Sentry.capture_exception(meta.error, stacktrace: meta.stacktrace)
    Logger.error(Exception.format(:error, meta.error, meta.stacktrace))
  end
end
