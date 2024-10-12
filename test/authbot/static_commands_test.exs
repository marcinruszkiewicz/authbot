defmodule Authbot.StaticCommandsTest do
  use Authbot.DataCase

  import Mock

  alias Authbot.Remotes.EveApi
  alias Authbot.StaticCommands
  alias Nostrum.Struct.Message

  test "evetime/1 responds with time and player count if eve api works" do
    message = %Message{
      guild_id: 1234,
      channel_id: 456,
      content: "!evetime"
    }

    with_mocks([
      {
        DateTime,
        [],
        [now: fn _ -> {:ok, ~U[2024-08-31 12:45:29.352180Z]} end]
      },
      {
        EveApi,
        [],
        [
          get: fn _url -> {:ok, %HTTPoison.Response{status_code: 200, body: [players: 17_001]}} end,
          start: fn -> nil end
        ]
      },
      {
        Nostrum.Api,
        [],
        [
          create_message: fn _channel, _options -> nil end,
          bulk_overwrite_guild_application_commands: fn _guild, _opts -> nil end
        ]
      }
    ]) do
      StaticCommands.evetime(message)

      assert_called(
        Nostrum.Api.create_message(456, "The current EVE time is 2024-08-31 12:45:29.\nThere are 17001 players online.")
      )
    end
  end

  test "evetime/1 responds only with time when api times out" do
    message = %Message{
      guild_id: 1234,
      channel_id: 456,
      content: "!evetime"
    }

    with_mocks([
      {
        DateTime,
        [],
        [now: fn _ -> {:ok, ~U[2024-08-31 12:45:29.352180Z]} end]
      },
      {
        EveApi,
        [],
        [
          get: fn _url -> {:ok, %HTTPoison.Response{status_code: 404, body: nil}} end,
          start: fn -> nil end
        ]
      },
      {
        Nostrum.Api,
        [],
        [
          create_message: fn _channel, _options -> nil end,
          bulk_overwrite_guild_application_commands: fn _guild, _opts -> nil end
        ]
      }
    ]) do
      StaticCommands.evetime(message)
      assert_called(Nostrum.Api.create_message(456, "The current EVE time is 2024-08-31 12:45:29."))
    end
  end
end
