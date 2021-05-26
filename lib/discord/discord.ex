defmodule Lookupex.Discord do
  require Logger

  import Lookupex.Discord.Util

  def lookup(id, timeout \\ 10_000) do
    Task.Supervisor.async(
      Lookupex.Discord.Supervisor,
      fn -> lookup_blocking(id) end
    )
    |> Task.await(timeout)
  end

  defp client do
    token = Application.get_env(:lookupex, Discord)[:token]

    if token == nil do
      raise ArgumentError, "DISCORD_API_TOKEN must be specified"
    end

    middleware = [
      {Tesla.Middleware.BaseUrl, "https://discord.com/api"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"authorization", "Bot " <> token}]}
    ]

    Tesla.client(middleware)
  end

  defp lookup_blocking(id) do
    Logger.info("lookup", id: id)

    if not check_id(id) do
      {%{code: 400, message: "invalid snowflake id"}, 400}
    else
      {request_count, data, status} = Lookupex.Cache.request_user!(id)

      {data, status} =
        if data == nil do
          {:ok, response} = Tesla.get(client(), "/users/" <> id)

          ok = response.status < 400

          body =
            if ok do
              response.body
              |> Map.put("avatar_url", get_avatar_url(response.body))
              |> Map.put("creation", get_id_creation(response.body["id"]))
              |> Map.put("flags_abstracted", abstract_flags(response.body["public_flags"]))
            else
              response.body
            end

          Lookupex.Cache.put_user!(id, body, response.status)

          {body, response.status}
        else
          {data, status}
        end

      data = if status < 400, do: data |> Map.put("request_count", request_count), else: data
      data = data |> Map.put("date", DateTime.utc_now())

      {data, status}
    end
  end
end
