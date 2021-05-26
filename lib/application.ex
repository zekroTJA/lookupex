defmodule Lookupex.Application do
  use Application
  require Logger

  def start(_type, _args) do
    ip = Application.get_env(:lookupex, Webserver)[:ip]
    port = Application.get_env(:lookupex, Webserver)[:port]

    children = [
      {
        Plug.Cowboy,
        plug: Lookupex.Webserver.Router,
        scheme: :http,
        options: [
          ip: Application.get_env(:lookupex, Webserver)[:ip],
          port: Application.get_env(:lookupex, Webserver)[:port]
        ]
      },
      {
        Task.Supervisor,
        name: Lookupex.Discord.Supervisor
      },
      Lookupex.Cache.Supervisor
    ]

    Logger.info("Webserver running at addr #{ip |> Tuple.to_list() |> Enum.join(":")}:#{port}")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lookupex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
