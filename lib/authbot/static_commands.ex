defmodule Authbot.StaticCommands do
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
end
