defmodule Lookupex.Cache.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(_state) do
    endpoint = Application.get_env(:lookupex, Redis)[:endpoint]

    if endpoint == nil do
      raise ArgumentError, "REDIS_ADDRESS must be specified"
    end

    children = [
      {Redix, {endpoint, [name: Lookupex.Cache.Connection]}}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
