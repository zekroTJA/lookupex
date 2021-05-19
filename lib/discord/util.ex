defmodule Lookupex.Discord.Util do
  import Bitwise

  @endpoint_cdn "https://cdn.discordapp.com"

  @snowflake_epoche 1_420_070_400_000

  def get_avatar_url(user) do
    id = user["id"]
    avatar = user["avatar"]
    discriminator = user["discriminator"]

    cond do
      avatar == nil or avatar == "" ->
        default_avatar(discriminator)

      avatar |> String.starts_with?("a_") ->
        "#{@endpoint_cdn}/avatars/#{id}/#{avatar}.gif"

      true ->
        "#{@endpoint_cdn}/avatars/#{id}/#{avatar}.png"
    end
  end

  def get_id_creation(id) when is_binary(id) do
    id |> String.to_integer() |> get_id_creation()
  end

  def get_id_creation(id) when is_integer(id) do
    ((id >>> 22) + @snowflake_epoche)
    |> DateTime.from_unix!(:millisecond)
  end

  defp default_avatar(discriminator) do
    discriminator |> IO.inspect()
    disc = String.to_integer(discriminator)
    "#{@endpoint_cdn}/embed/avatars/#{rem(disc, 5)}.png"
  end
end
