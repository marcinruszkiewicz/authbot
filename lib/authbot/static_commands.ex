defmodule Authbot.StaticCommands do
  # Evetime and player count
  # Usage: !evetime
  def evetime(msg) do
    Authbot.Remotes.EveApi.start

    time =
      DateTime.now("Etc/UTC")
      |> elem(1)
      |> Calendar.strftime("%c")

    reply = "The current EVE time is #{time}."

    reply =
      case Authbot.Remotes.EveApi.get("/status") do
        {:ok, %HTTPoison.Response{status_code: 200} = response} ->
          player_count = response.body[:players]

          reply <> "\nThere are #{player_count} players online."
        _ ->
          reply
      end

    Authbot.BotConsumer.send_message(reply, msg)
  end
end
