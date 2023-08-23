defmodule Authbot.BotConsumer do
  use Nostrum.Consumer
  alias Nostrum.Api

  def start_link do
    Consumer.start_link(__MODULE__)
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

    # case Api.add_guild_member_role(guild_id, member_id, role_id) do
    #   {:ok} ->
    #     Api.create_message(1000108700175966321, "added role")
    #   {:error, error} ->
    #     Api.create_message(1000108700175966321, inspect(error))
    # end
  end
end
