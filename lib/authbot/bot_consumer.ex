defmodule Authbot.BotConsumer do
  use Nostrum.Consumer

  alias Nostrum.Api
  alias Nostrum.Struct.Interaction
  alias Authbot.Guilds

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:READY, info, _ws_state}) do
    Enum.each(info.guilds, fn g ->
      Guilds.create_guild_config(g.id)
      setup_commands(g.id)
    end)
  end

  # Event handler for text messages. First we check if it's a known static command,
  # then we look it up in dynamic command table if it's there.
  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    command =
      msg.content
      |> String.split(" ", parts: 2, trim: true)
      |> List.first

    if Enum.member?(static_commands(), command) do
      method =
        command
        |> String.replace_prefix("!", "")
        |> String.to_atom

      apply(Authbot.StaticCommands, method, [msg])
    else
      :ignore
    end
  end

  # handle incoming interactions (slash commands)
  def handle_event({:INTERACTION_CREATE, %Interaction{data: %{name: "auth"}} = interaction, _ws_state}) do
    text = "Click the following link and authorize using both your Discord and goonfleet dot com usernames to receive an appropriate role:\nhttps://atauth.aevi.pl/#{interaction.guild_id}/step1"

    response = %{
      type: 4,
      data: %{
        content: text,
        flags: 64 # ephemeral message flag
      }
    }
    Api.create_interaction_response(interaction, response)
  end

  def handle_event({:INTERACTION_CREATE, %Interaction{data: %{name: "role"}} = interaction, _ws_state}) do
    manage_role(interaction)
  end

  def handle_event({:INTERACTION_CREATE, %Interaction{data: %{name: "assignable_role"}} = interaction, _ws_state}) do
    manage_assignable_role(interaction)
  end

  def handle_event({:INTERACTION_CREATE, %Interaction{data: %{name: "config"}} = interaction, _ws_state}) do
    manage_config(interaction)
  end

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event(_event) do
    :noop
  end

  defp manage_role(%Interaction{data: %{options: [%{value: role_id}, %{value: "assign"}]}} = interaction) do
    IO.inspect Api.add_guild_member_role(interaction.guild_id, interaction.member.user_id, role_id)

    response = %{
      type: 4,  # ChannelMessageWithSource
      data: %{
        content: "Role assigned.",
        flags: 64 # ephemeral message flag
      }
    }
    Api.create_interaction_response(interaction, response)
  end

  defp manage_role(%Interaction{data: %{options: [%{value: role_id}, %{value: "remove"}]}} = interaction) do
    Api.remove_guild_member_role(interaction.guild_id, interaction.member.user_id, role_id)

    response = %{
      type: 4,  # ChannelMessageWithSource
      data: %{
        content: "Role removed.",
        flags: 64 # ephemeral message flag
      }
    }
    Api.create_interaction_response(interaction, response)
  end

  defp manage_assignable_role(%Interaction{data: %{options: [%{value: role_id}, %{value: "add"}]}} = interaction) do
    Guilds.add_guild_assignable_role(interaction.guild_id, role_id, interaction.data.resolved.roles[role_id].name)
    setup_commands(interaction.guild_id)

    response = %{
      type: 4,  # ChannelMessageWithSource
      data: %{
        content: "Role added as assignable.",
        flags: 64 # ephemeral message flag
      }
    }
    Api.create_interaction_response(interaction, response)
  end

  defp manage_assignable_role(%Interaction{data: %{options: [%{value: role_id}, %{value: "remove"}]}} = interaction) do
    Guilds.remove_guild_assignable_role(interaction.guild_id, role_id)
    setup_commands(interaction.guild_id)

    response = %{
      type: 4,  # ChannelMessageWithSource
      data: %{
        content: "Role removed from assignable roles list.",
        flags: 64 # ephemeral message flag
      }
    }
    Api.create_interaction_response(interaction, response)
  end

  defp manage_config(%Interaction{data: %{options: [%{value: role_id}, %{value: "verified"}]}} = interaction) do
    config = Guilds.get_config_by_guild_id(interaction.guild_id)
    Guilds.update_config(config, %{verified_role_id: role_id})
    setup_commands(interaction.guild_id)

    response = %{
      type: 4,  # ChannelMessageWithSource
      data: %{
        content: "Config changed.",
        flags: 64 # ephemeral message flag
      }
    }
    Api.create_interaction_response(interaction, response)
  end

  defp manage_config(%Interaction{data: %{options: [%{value: role_id}, %{value: "gsf"}]}} = interaction) do
    config = Guilds.get_config_by_guild_id(interaction.guild_id)
    Guilds.update_config(config, %{gsf_role_id: role_id})
    setup_commands(interaction.guild_id)

    response = %{
      type: 4,  # ChannelMessageWithSource
      data: %{
        content: "Config changed.",
        flags: 64 # ephemeral message flag
      }
    }
    Api.create_interaction_response(interaction, response)
  end

  defp manage_config(%Interaction{data: %{options: [%{value: role_id}, %{value: "ally"}]}} = interaction) do
    config = Guilds.get_config_by_guild_id(interaction.guild_id)
    Guilds.update_config(config, %{ally_role_id: role_id})
    setup_commands(interaction.guild_id)

    response = %{
      type: 4,  # ChannelMessageWithSource
      data: %{
        content: "Config changed.",
        flags: 64 # ephemeral message flag
      }
    }
    Api.create_interaction_response(interaction, response)
  end

  # Send text message to Discord api in the same channel we received a message
  def send_message(text, msg) do
    Api.create_message(msg.channel_id, text)
  end

  # Add reaction emojis (which are just unicode strings) to a message we received
  # Notrum automatically throttles this so it isn't instant.
  def react(reaction, msg) do
    for string <- String.split(reaction) do
      Api.create_reaction(msg.channel_id, msg.id, string)
    end
  end

  def send_embed(embed, msg) do
    Api.create_message(msg.channel_id, embeds: [embed])
  end

  # Get the list of static commands (which are just defined functions) from the StaticCommands module.
  # If it's not there, the bot doesn't respond to it.
  def static_commands do
    Authbot.StaticCommands.__info__(:functions)
    |> Enum.map(fn {cmd, _arity} -> "!#{cmd}" end)
  end

  def give_role(guild_id, member_id, role_id) do
    Api.add_guild_member_role(guild_id, member_id, role_id)
  end

  defp setup_commands(guild_id) do
    role_choices =
      Guilds.list_guild_assignable_roles(guild_id)
      |> Enum.map(fn r ->
        %{
          name: r.name,
          value: "#{r.role_id}"
        }
      end)

    role = %{
      name: "role",
      description: "assign or remove a role",
      options: [
        %{
          type: 3,
          name: "role",
          description: "role to assign or remove",
          required: true,
          choices: role_choices
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

    authlink = %{
      name: "auth",
      description: "show an authorization link so you can be assigned a proper role"
    }

    assignable_role = %{
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
    }

    bot_config = %{
      name: "config",
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
    }

    Api.bulk_overwrite_guild_application_commands(guild_id, [role, authlink, assignable_role, bot_config])
  end
end
