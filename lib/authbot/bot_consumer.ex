defmodule Authbot.BotConsumer do
  use Nostrum.Consumer

  alias Nostrum.Api
  alias Nostrum.Struct.Interaction
  alias Authbot.{Guilds, Debug, ApplicationCommands}

  def handle_event({:READY, info, _ws_state}) do
    Enum.each(info.guilds, fn g ->
      Guilds.create_guild_config(g.id)
      ApplicationCommands.setup_commands(g.id)
      ApplicationCommands.setup_role_command(g.id)
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
    ApplicationCommands.manage_role(interaction)
  end

  def handle_event({:INTERACTION_CREATE, %Interaction{data: %{name: "assignable_role"}} = interaction, _ws_state}) do
    ApplicationCommands.manage_assignable_role(interaction)
  end

  def handle_event({:INTERACTION_CREATE, %Interaction{data: %{name: "role_config"}} = interaction, _ws_state}) do
    ApplicationCommands.manage_role_config(interaction)
  end

  def handle_event({:INTERACTION_CREATE, %Interaction{data: %{name: "server_config"}} = interaction, _ws_state}) do
    ApplicationCommands.manage_server_config(interaction)
  end

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event(_event) do
    :noop
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
    |> Kernel.inspect
    |> Debug.log_response("give_role")
  end

  def change_nickname(guild_id, member_id, new_nick) do
    Api.modify_guild_member(String.to_integer(guild_id), member_id, nick: new_nick)
    |> Kernel.inspect
    |> Debug.log_response("change_nickname")
  end
end
