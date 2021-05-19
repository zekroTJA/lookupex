defmodule Lookupex.Discord.Util do
  @endpoint_cdn "https://cdn.discordapp.com"

  def get_avatar_url(user) do
    id = user["id"]
    avatar = user["avatar"]
    discriminator = user["discriminator"]

    cond do
      avatar == nil or avatar == "" ->
        _default_avatar(discriminator)

      avatar |> String.starts_with?("a_") ->
        "#{@endpoint_cdn}/avatars/#{id}/#{avatar}.gif"

      true ->
        "#{@endpoint_cdn}/avatars/#{id}/#{avatar}.png"
    end
  end

  def _default_avatar(discriminator) do
    discriminator |> IO.inspect()
    disc = String.to_integer(discriminator)
    "#{@endpoint_cdn}/embed/avatars/#{rem(disc, 5)}.png"
  end
end
