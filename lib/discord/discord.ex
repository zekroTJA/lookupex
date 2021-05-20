defmodule Lookupex.Discord do
  use GenServer
  require Logger

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
    Logger.info("lookup", id: id)

    if not check_id(id) do
      {:reply, {%{code: 400, message: "invalid snowflake id"}, 400}, state}
    else
      {request_count, data, status} = Lookupex.Cache.request_user(id)

      {data, status} =
        if data == nil do
          {:ok, response} = Tesla.get(state[:client], "/users/" <> id)

          ok = response.status < 400

          body =
            if ok do
              response.body
              |> Map.put("avatar_url", get_avatar_url(response.body))
              |> Map.put("creation", get_id_creation(response.body["id"]))
              |> Map.put("request_count", request_count)
              |> Map.put("flags_abstracted", abstract_flags(response.body["public_flags"]))
            else
              response.body
            end

          Lookupex.Cache.put_user(id, body, response.status)

          {body, response.status}
        else
          {data, status}
        end

      data = data |> Map.put("date", DateTime.utc_now())

      {:reply, {data, status}, state}
    end
  end
end
