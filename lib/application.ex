defmodule Lookupex.Application do
  use Application
  require Logger

  def start(_type, _args) do
    Envy.auto_load()

    bind_split = System.get_env("BIND_ADDRESS", "0.0.0.0") |> String.split(":")
    bind_split = if length(bind_split) < 2, do: bind_split ++ ["8080"], else: bind_split

    ip =
      bind_split
      |> Enum.at(0)
      |> String.split(".")
      |> Enum.map(fn e -> Integer.parse(e) end)
      |> Enum.map(fn {v, _} -> v end)

    {port, _} = Integer.parse(bind_split |> Enum.at(1))

    children = [
      {
        Plug.Cowboy,
        plug: Lookupex.Webserver.Router,
        scheme: :http,
        options: [
          ip: {Enum.at(ip, 0), Enum.at(ip, 1), Enum.at(ip, 2), Enum.at(ip, 3)},
          port: port
        ]
      },
      Lookupex.Discord,
      Lookupex.Cache
    ]

    Logger.info("Webserver running at addr #{bind_split |> Enum.join(":")}")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lookupex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
