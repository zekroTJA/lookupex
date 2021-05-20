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

  def check_id(id) when is_binary(id) do
    case id |> Integer.parse() do
      :error ->
        false

      {v, b} ->
        if String.length(b) > 0 do
          false
        else
          check_id(v)
        end
    end
  end

  def check_id(id) when is_integer(id) do
    id > 1_420_070_400_000
  end

  def abstract_flags(flags) do
    abstracted = [] |> put_flag_abstraction(flags, 0, "discord_employee")
    abstracted = abstracted |> put_flag_abstraction(flags, 1, "partnered_server_owner")
    abstracted = abstracted |> put_flag_abstraction(flags, 2, "hypesquad_events")
    abstracted = abstracted |> put_flag_abstraction(flags, 3, "bughunter_level_1")
    abstracted = abstracted |> put_flag_abstraction(flags, 6, "house_bravery")
    abstracted = abstracted |> put_flag_abstraction(flags, 7, "house_brilliance")
    abstracted = abstracted |> put_flag_abstraction(flags, 8, "house_balance")
    abstracted = abstracted |> put_flag_abstraction(flags, 9, "early_supporter")
    abstracted = abstracted |> put_flag_abstraction(flags, 10, "team_user")
    abstracted = abstracted |> put_flag_abstraction(flags, 14, "bughunter_level_2")
    abstracted = abstracted |> put_flag_abstraction(flags, 16, "verified_bot")
    abstracted = abstracted |> put_flag_abstraction(flags, 17, "early_cerified_developer")

    abstracted
  end

  defp default_avatar(discriminator) do
    disc = String.to_integer(discriminator)
    "#{@endpoint_cdn}/embed/avatars/#{rem(disc, 5)}.png"
  end

  defp put_flag_abstraction(abstractions, flags, shift, abstraction) do
    if (flags &&& 1 <<< shift) != 0 do
      [abstraction | abstractions]
    else
      abstractions
    end
  end
end
