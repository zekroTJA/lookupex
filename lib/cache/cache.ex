defmodule Lookupex.Cache do
  use GenServer

  @name __MODULE__

  @user_data_lifetime 600
  @namespace_user_data "USER:DATA"
  @namespace_user_stats_accesses "USER:STATS:ACCESSES"

  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  def init(_state) do
    redis_address = System.get_env("REDIS_ADDRESS")
    if redis_address == nil, do: raise("no Redis address provided")

    {:ok, conn} = Redix.start_link(redis_address, name: :redix)
    Redix.command!(conn, ["PING"])

    {:ok, %{client: conn}}
  end

  ### API ###

  def put_user(user_id, data, status \\ 200, pid \\ @name) do
    data = data |> Map.put("_status", status)
    GenServer.cast(pid, {:set, "#{@namespace_user_data}:#{user_id}", data, @user_data_lifetime})
  end

  def request_user(user_id, pid \\ @name) do
    request_count = GenServer.call(pid, {:incr, "#{@namespace_user_stats_accesses}:#{user_id}"})
    data = GenServer.call(pid, {:get, "#{@namespace_user_data}:#{user_id}"})

    status = if data != nil, do: data["_status"], else: 404
    data = if data != nil, do: data |> Map.delete("_status"), else: data

    {request_count, data, status}
  end

  ### CALLBACKS ###

  def handle_cast({:set, key, value, timeout}, state) do
    value_str = Jason.encode!(value)
    cmd = ["SET", key, value_str]

    cmd = if timeout != nil, do: cmd ++ ["EX", timeout], else: cmd

    Redix.command!(state[:client], cmd)

    {:noreply, state}
  end

  def handle_call({:incr, key}, _from, state) do
    cmd = ["INCR", key]
    res = Redix.command!(state[:client], cmd)

    {:reply, res, state}
  end

  def handle_call({:get, key}, _from, state) do
    res = Redix.command!(state[:client], ["GET", key])

    value = if res != nil, do: Jason.decode!(res), else: nil

    {:reply, value, state}
  end
end
