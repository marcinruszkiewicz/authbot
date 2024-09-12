defmodule Authbot.ApplicationCommands do
  alias Nostrum.Api
  alias Nostrum.Struct.Interaction
  alias Authbot.Guilds

  def manage_role(%Interaction{data: %{options: [%{value: role_id}, %{value: "assign"}]}} = interaction) do
    Api.add_guild_member_role(interaction.guild_id, interaction.member.user_id, role_id)

    response = %{
      type: 4,  # ChannelMessageWithSource
      data: %{
        content: "Role assigned.",
        flags: 64 # ephemeral message flag
      }
    }
    Api.create_interaction_response(interaction, response)
  end

  def manage_role(%Interaction{data: %{options: [%{value: role_id}, %{value: "remove"}]}} = interaction) do
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

  def manage_assignable_role(%Interaction{data: %{options: [%{value: role_id}, %{value: "add"}]}} = interaction) do
    Guilds.add_guild_assignable_role(interaction.guild_id, role_id, interaction.data.resolved.roles[role_id].name)
    setup_role_command(interaction.guild_id)

    response = %{
      type: 4,  # ChannelMessageWithSource
      data: %{
        content: "Role added as assignable.",
        flags: 64 # ephemeral message flag
      }
    }
    Api.create_interaction_response(interaction, response)
  end

  def manage_assignable_role(%Interaction{data: %{options: [%{value: role_id}, %{value: "remove"}]}} = interaction) do
    Guilds.remove_guild_assignable_role(interaction.guild_id, role_id)
    setup_role_command(interaction.guild_id)

    response = %{
      type: 4,  # ChannelMessageWithSource
      data: %{
        content: "Role removed from assignable roles list.",
        flags: 64 # ephemeral message flag
      }
    }
    Api.create_interaction_response(interaction, response)
  end

  def manage_server_config(%Interaction{data: %{options: [%{name: "alliance_ticker", value: alliance_ticker}]}} = interaction) do
    config = Guilds.get_config_by_guild_id(interaction.guild_id)
    Guilds.update_config(config, %{alliance_ticker: alliance_ticker})

    response = %{
      type: 4,  # ChannelMessageWithSource
      data: %{
        content: "Config changed.",
        flags: 64 # ephemeral message flag
      }
    }
    Api.create_interaction_response(interaction, response)
  end

  def manage_role_config(%Interaction{data: %{options: [%{value: role_id}, %{value: "verified"}]}} = interaction) do
    config = Guilds.get_config_by_guild_id(interaction.guild_id)
    Guilds.update_config(config, %{verified_role_id: role_id})
    setup_role_command(interaction.guild_id)

    response = %{
      type: 4,  # ChannelMessageWithSource
      data: %{
        content: "Config changed.",
        flags: 64 # ephemeral message flag
      }
    }
    Api.create_interaction_response(interaction, response)
  end

  def manage_role_config(%Interaction{data: %{options: [%{value: role_id}, %{value: "gsf"}]}} = interaction) do
    config = Guilds.get_config_by_guild_id(interaction.guild_id)
    Guilds.update_config(config, %{gsf_role_id: role_id})
    setup_role_command(interaction.guild_id)

    response = %{
      type: 4,  # ChannelMessageWithSource
      data: %{
        content: "Config changed.",
        flags: 64 # ephemeral message flag
      }
    }
    Api.create_interaction_response(interaction, response)
  end

  def manage_role_config(%Interaction{data: %{options: [%{value: role_id}, %{value: "ally"}]}} = interaction) do
    config = Guilds.get_config_by_guild_id(interaction.guild_id)
    Guilds.update_config(config, %{ally_role_id: role_id})
    setup_role_command(interaction.guild_id)

    response = %{
      type: 4,  # ChannelMessageWithSource
      data: %{
        content: "Config changed.",
        flags: 64 # ephemeral message flag
      }
    }
    Api.create_interaction_response(interaction, response)
  end

  def setup_commands(guild_id) do
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

    role_config = %{
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
    }

    server_config = %{
      name: "server_config",
      description: "Configure other things",
      default_member_permissions: 8, # admin
      options: [
        %{
            name: "alliance_ticker",
            description: "Add alliance tags to names when using auth command",
            type: 5,
            required: true
        }
      ]
    }

    Api.bulk_overwrite_guild_application_commands(guild_id, [authlink, assignable_role, role_config, server_config])
  end

  def setup_role_command(guild_id) do
    role_choices =
      Guilds.list_guild_assignable_roles(guild_id)
      |> Enum.map(fn r ->
        %{
          name: r.name,
          value: "#{r.role_id}"
        }
      end)
      |> Enum.uniq

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

    Api.create_guild_application_command(guild_id, role)
  end
end
