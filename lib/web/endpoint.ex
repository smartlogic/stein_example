defmodule Web.Endpoint do
  use Sentry.PlugCapture
  use Phoenix.Endpoint, otp_app: :stein_example

  alias SteinExample.Config

  if sandbox = Application.compile_env(:stein_example, :sandbox) do
    plug Phoenix.Ecto.SQL.Sandbox, sandbox: sandbox
  end

  socket "/socket", Web.UserSocket,
    websocket: true,
    longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :stein_example,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Sentry.PlugContext

  plug Plug.MethodOverride
  plug Plug.Head
  plug Logster.Plugs.Logger

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_stein_example_key",
    signing_salt: "76sn4b3J"

  if Mix.env() == :dev do
    plug(Plug.Static, at: "/uploads", from: "uploads/files")
  end

  plug Web.Router

  def init(_type, config) do
    vapor_config = Config.endpoint()

    config =
      Keyword.merge(config,
        http: [port: vapor_config.http_port],
        secret_key_base: vapor_config.secret_key_base,
        url: [
          host: vapor_config.url_host,
          port: vapor_config.url_port,
          scheme: vapor_config.url_scheme
        ]
      )

    {:ok, config}
  end
end
