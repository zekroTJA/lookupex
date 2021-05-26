defmodule Lookupex.Cache do
  alias Lookupex.Cache.Connection

  @user_data_lifetime 600
  @namespace_user_data "LUX:USER:DATA"
  @namespace_user_stats_accesses "LUX:USER:STATS:ACCESSES"

  def put_user!(user_id, data, status \\ 200) do
    data = data |> Map.put("_status", status)
    set!("#{@namespace_user_data}:#{user_id}", data, @user_data_lifetime)
  end

  def request_user!(user_id) do
    request_count = incr!("#{@namespace_user_stats_accesses}:#{user_id}")
    data = get!("#{@namespace_user_data}:#{user_id}")

    status = if data != nil, do: data["_status"], else: 404
    data = if data != nil, do: data |> Map.delete("_status"), else: data

    {request_count, data, status}
  end

  defp set!(key, value, timeout) do
    value_str = Jason.encode!(value)
    cmd = ["SET", key, value_str]

    cmd = if timeout != nil, do: cmd ++ ["EX", timeout], else: cmd

    Redix.command!(Connection, cmd)
  end

  defp incr!(key) do
    cmd = ["INCR", key]
    Redix.command!(Connection, cmd)
  end

  defp get!(key) do
    res = Redix.command!(Connection, ["GET", key])
    if res != nil, do: Jason.decode!(res), else: nil
  end
end
