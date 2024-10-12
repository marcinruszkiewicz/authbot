defmodule Authbot.StaticCommands do
  # Evetime and player count
  # Usage: !evetime
  @moduledoc false
  alias Authbot.Remotes.EveApi

  def evetime(msg) do
    EveApi.start()

    time =
      "Etc/UTC"
      |> DateTime.now()
      |> elem(1)
      |> Calendar.strftime("%c")

    reply = "The current EVE time is #{time}."

    reply =
      case EveApi.get("/status") do
        {:ok, %HTTPoison.Response{status_code: 200} = response} ->
          player_count = response.body[:players]

          reply <> "\nThere are #{player_count} players online."

        _ ->
          reply
      end

    Authbot.BotConsumer.send_message(reply, msg)
  end
end
