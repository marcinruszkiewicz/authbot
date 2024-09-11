defmodule Authbot.BotConsumerTest do
  use Authbot.DataCase
  import Authbot.Factory
  import Mock

  alias Authbot.BotConsumer
  alias Nostrum.Struct.{WSState, Event, Guild, Interaction, Message}

  describe "on unhandled events" do
    setup do
      reaction_event = {:MESSAGE_REACTION_ADD, %Event.MessageReactionAdd{}, %WSState{}}

      {:ok, event: reaction_event}
    end

    test "handler returns noop", %{event: event} do
      assert BotConsumer.handle_event(event) == :noop
    end
  end

  describe "on READY event" do
    setup do
      guild = %Guild.UnavailableGuild{id: 1234, unavailable: true}
      ready = %Event.Ready{guilds: [guild]}
      ready_event = {:READY, ready, %WSState{}}
      expected_response = [
        %{
          name: "auth",
          description: "show an authorization link so you can be assigned a proper role"
        },
        %{
          name: "assignable_role",
          description: "Add a role to a list of those that users can assign themselves",
          default_member_permissions: 8, # admin
          options: [
            %{
              # ApplicationCommandType::ROLE
              type: 8,
              name: "name",
              description: "role to add or remove",
              required: true
            },
            %{
              # ApplicationCommandType::STRING
              type: 3,
              name: "action",
              description: "whether to add or remove the role from the list",
              required: true,
              choices: [
                %{
                  name: "add",
                  value: "add"
                },
                %{
                  name: "remove",
                  value: "remove"
                }
              ]
            }
          ]
        },
        %{
          name: "role_config",
          description: "Choose roles to serve as verified or gsf/ally roles.",
          default_member_permissions: 8, # admin
          options: [
            %{
              # ApplicationCommandType::ROLE
              type: 8,
              name: "name",
              description: "role to add or remove",
              required: true
            },
            %{
              # ApplicationCommandType::STRING
              type: 3,
              name: "action",
              description: "whether to add or remove the role from the list",
              required: true,
              choices: [
                %{
                  name: "verified",
                  value: "verified"
                },
                %{
                  name: "gsf",
                  value: "gsf"
                },
                %{
                  name: "ally",
                  value: "ally"
                }
              ]
            }
          ]
        },
        %{
          name: "server_config",
          description: "Configure other things",
          default_member_permissions: 8, # admin
          options: [
            %{
                name: "alliance_ticker",
                description: "Add alliance tags to names when using auth command",
                type: 5
            }
          ]
        }
      ]

      role_response = %{
        name: "role",
        description: "assign or remove a role",
        options: [
          %{
            type: 3,
            name: "role",
            description: "role to assign or remove",
            required: true,
            choices: []
          },
          %{
            type: 3,
            name: "action",
            description: "whether to assign or remove the role",
            required: true,
            choices: [
              %{
                name: "assign",
                value: "assign"
              },
              %{
                name: "remove",
                value: "remove"
              }
            ]
          }
        ]
      }

      {:ok, event: ready_event, response: expected_response, role: role_response}
    end

    test "handler adds bot commands to discord server", %{event: event, response: response, role: role} do
      with_mocks([
        {
          Nostrum.Api, [],
          [
            bulk_overwrite_guild_application_commands: fn(_guild, _opts) -> nil end,
            create_guild_application_command: fn(_guild, _opts) -> nil end
          ]
        }
      ]) do
        BotConsumer.handle_event(event)
        assert_called Nostrum.Api.bulk_overwrite_guild_application_commands(1234, response)
        assert_called Nostrum.Api.create_guild_application_command(1234, role)
      end
    end
  end

  describe "on READY event with assignable roles setup" do
    setup do
      insert(:assignable_role, guild_id: 456, name: "Logi", role_id: 1)

      guild = %Guild.UnavailableGuild{id: 456, unavailable: true}
      ready = %Event.Ready{guilds: [guild]}
      ready_event = {:READY, ready, %WSState{}}
      expected_response = [
        %{
          name: "auth",
          description: "show an authorization link so you can be assigned a proper role"
        },
        %{
          name: "assignable_role",
          description: "Add a role to a list of those that users can assign themselves",
          default_member_permissions: 8, # admin
          options: [
            %{
              # ApplicationCommandType::ROLE
              type: 8,
              name: "name",
              description: "role to add or remove",
              required: true
            },
            %{
              # ApplicationCommandType::STRING
              type: 3,
              name: "action",
              description: "whether to add or remove the role from the list",
              required: true,
              choices: [
                %{
                  name: "add",
                  value: "add"
                },
                %{
                  name: "remove",
                  value: "remove"
                }
              ]
            }
          ]
        },
        %{
          name: "role_config",
          description: "Choose roles to serve as verified or gsf/ally roles.",
          default_member_permissions: 8, # admin
          options: [
            %{
              # ApplicationCommandType::ROLE
              type: 8,
              name: "name",
              description: "role to add or remove",
              required: true
            },
            %{
              # ApplicationCommandType::STRING
              type: 3,
              name: "action",
              description: "whether to add or remove the role from the list",
              required: true,
              choices: [
                %{
                  name: "verified",
                  value: "verified"
                },
                %{
                  name: "gsf",
                  value: "gsf"
                },
                %{
                  name: "ally",
                  value: "ally"
                }
              ]
            }
          ]
        },
        %{
          name: "server_config",
          description: "Configure other things",
          default_member_permissions: 8, # admin
          options: [
            %{
                name: "alliance_ticker",
                description: "Add alliance tags to names when using auth command",
                type: 5
            }
          ]
        }
      ]

      role_response = %{
        name: "role",
        description: "assign or remove a role",
        options: [
          %{
            type: 3,
            name: "role",
            description: "role to assign or remove",
            required: true,
            choices: [%{name: "Logi", value: "1"}]
          },
          %{
            type: 3,
            name: "action",
            description: "whether to assign or remove the role",
            required: true,
            choices: [
              %{
                name: "assign",
                value: "assign"
              },
              %{
                name: "remove",
                value: "remove"
              }
            ]
          }
        ]
      }

      {:ok, event: ready_event, response: expected_response, role: role_response}
    end

    test "handler adds bot commands to discord server", %{event: event, response: response, role: role} do
      with_mocks([
        {
          Nostrum.Api, [],
          [
            bulk_overwrite_guild_application_commands: fn(_guild, _opts) -> nil end,
            create_guild_application_command: fn(_guild, _opts) -> nil end
          ]
        }
      ]) do
        BotConsumer.handle_event(event)
        assert_called Nostrum.Api.bulk_overwrite_guild_application_commands(456, response)
        assert_called Nostrum.Api.create_guild_application_command(456, role)
      end
    end
  end

  describe "on /auth INTERACTION event" do
    setup do
      interaction = %Interaction{
        guild_id: 12345,
        data: %{
          name: "auth"
        }
      }
      interaction_event = {:INTERACTION_CREATE, interaction, %WSState{}}
      expected_response = %{
        data: %{
          flags: 64,
          content: "Click the following link and authorize using both your Discord and goonfleet dot com usernames to receive an appropriate role:\nhttps://atauth.aevi.pl/12345/step1"
        },
        type: 4
      }

      {:ok, event: interaction_event, response: expected_response, interaction: interaction}
    end

    test "handler returns a link to authorization page", %{event: event, response: response, interaction: interaction} do
      with_mocks([
        {
          Nostrum.Api, [],
          [
            create_interaction_response: fn(_guild, _opts) -> nil end
          ]
        }
      ]) do
        BotConsumer.handle_event(event)
        assert_called Nostrum.Api.create_interaction_response(interaction, response)
      end
    end
  end

  describe "on MESSAGE event" do
    setup do
      message = %Message{
        guild_id: 1234,
        channel_id: 456,
        content: "!evetime"
      }
      command_message_event = {:MESSAGE_CREATE, message, %WSState{}}

      bad_message = %Message{
        guild_id: 1234,
        channel_id: 456,
        content: "this should be ignored"
      }
      bad_message_event = {:MESSAGE_CREATE, bad_message, %WSState{}}

      {:ok, ok_event: command_message_event, bad_event: bad_message_event}
    end

    test "other message content is ignored", %{bad_event: event} do
      assert BotConsumer.handle_event(event) == :ignore
    end

    test "handles the !evetime command if API doesn't respond", %{ok_event: event} do
      with_mocks([
        {
          DateTime, [],
          [now: fn(_) -> {:ok, ~U[2024-08-31 12:45:29.352180Z]} end]
        },
        {
          Authbot.Remotes.EveApi, [],
          [
            get: fn(_url) -> {:ok, %HTTPoison.Response{status_code: 404, body: nil}} end,
            start: fn -> nil end
          ]
        },
        {
          Nostrum.Api, [],
          [
            create_message: fn(_channel, _options) -> nil end,
            bulk_overwrite_guild_application_commands: fn(_guild, _opts) -> nil end
          ]
        }
      ]) do
        BotConsumer.handle_event(event)
        assert_called Nostrum.Api.create_message(456, "The current EVE time is 2024-08-31 12:45:29.")
      end
    end

    test "handles the !evetime command if API works", %{ok_event: event} do
      with_mocks([
        {
          DateTime, [],
          [now: fn(_) -> {:ok, ~U[2024-08-31 12:45:29.352180Z]} end]
        },
        {
          Authbot.Remotes.EveApi, [],
          [
            get: fn(_url) -> {:ok, %HTTPoison.Response{status_code: 200, body: [players: 17_001]}} end,
            start: fn -> nil end
          ]
        },
        {
          Nostrum.Api, [],
          [
            create_message: fn(_channel, _options) -> nil end,
            bulk_overwrite_guild_application_commands: fn(_guild, _opts) -> nil end
          ]
        }
      ]) do
        BotConsumer.handle_event(event)

        assert_called Nostrum.Api.create_message(456, "The current EVE time is 2024-08-31 12:45:29.\nThere are 17001 players online.")
      end
    end
  end

  describe "give_role/3" do
    test "sets user role as requested and saves the debug log of it" do
      with_mocks([
        {
          Nostrum.Api, [],
          [
            add_guild_member_role: fn(_guild, _member, _role) -> nil end
          ]
        }
      ]) do
        BotConsumer.give_role(1234, 1, 1)
        assert_called Nostrum.Api.add_guild_member_role(1234, 1, 1)
      end
    end
  end

  describe "change_nickname/3" do
    test "sets user role as requested and saves the debug log of it" do
      with_mocks([
        {
          Nostrum.Api, [],
          [
            modify_guild_member: fn(_guild, _member, nick: _nick) -> nil end
          ]
        }
      ]) do
        BotConsumer.change_nickname("1234", 1, nick: "new")
        assert_called Nostrum.Api.modify_guild_member(1234, 1, [nick: [nick: "new"]])
      end
    end
  end

  describe "send_embed/2" do
    setup do
      message = %Message{
        guild_id: 1234,
        channel_id: 456,
        content: "embed"
      }

      {:ok, message: message}
    end

    test "sets user role as requested and saves the debug log of it", %{message: message} do
      with_mocks([
        {
          Nostrum.Api, [],
          [
            create_message: fn(_channel, _options) -> nil end
          ]
        }
      ]) do
        BotConsumer.send_embed(message, message)
        assert_called Nostrum.Api.create_message(456, embeds: [message])
      end
    end
  end

  describe "react/2" do
    setup do
      message = %Message{
        guild_id: 1234,
        channel_id: 456,
        content: "embed"
      }

      {:ok, message: message}
    end

    test "sets user role as requested and saves the debug log of it", %{message: message} do
      with_mocks([
        {
          Nostrum.Api, [],
          [
            create_reaction: fn(_channel, _message, _string) -> nil end
          ]
        }
      ]) do
        BotConsumer.react(":sun:", message)
        assert_called Nostrum.Api.create_reaction(456, nil, ":sun:")
      end
    end
  end

end
