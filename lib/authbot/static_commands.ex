defmodule Authbot.StaticCommands do
  alias Nostrum.Api

  # Evetime and player count
  # Usage: !evetime
  def evetime(msg) do
    Authbot.Remotes.EveApi.start

    time =
      DateTime.now("Etc/UTC")
      |> elem(1)
      |> Calendar.strftime("%c")

    player_count = Authbot.Remotes.EveApi.get!("/status").body[:players]

    "The current EVE time is #{time}.\nThere are #{player_count} players online."
    |> Authbot.BotConsumer.send_message(msg)
  end

  def debug_chat(msg) do
    {:ok, roles} = Api.get_guild_roles(msg.guild_id)

    roles = roles |> Enum.reject(fn r -> r.name == "@everyone" end)

    "Guild ID: #{msg.guild_id}\nChannel ID: #{msg.channel_id}\n\nRoles: #{inspect roles}"
    |> Authbot.BotConsumer.send_message(msg)
  end
end
