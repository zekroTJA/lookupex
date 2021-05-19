defmodule Lookupex.Discord do
  use GenServer

  import Lookupex.Discord.Util

  @name __MODULE__

  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  def init(_state) do
    api_token = System.get_env("DISCORD_API_TOKEN")
    if api_token == nil, do: raise("no API token provided")

    {:ok, %{client: client(api_token)}}
  end

  def client(token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://discord.com/api"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"authorization", "Bot " <> token}]}
    ]

    Tesla.client(middleware)
  end

  ### API ###

  def lookup(id, pid \\ @name) do
    GenServer.call(pid, {:lookup, id})
  end

  ### CALLBACKS ###

  def handle_call({:lookup, id}, _from, state) do
    {request_count, data} = Lookupex.Cache.request_user(id)

    {data, status} =
      if data == nil do
        {:ok, response} = Tesla.get(state[:client], "/users/" <> id)

        body =
          response.body
          |> Map.put("date", DateTime.utc_now())
          |> Map.put("avatar_url", get_avatar_url(response.body))

        Lookupex.Cache.put_user(id, body)
        {body, response.status}
      else
        {data, 200}
      end

    data = data |> Map.put("request_count", request_count)

    {:reply, {data, status}, state}
  end
end
