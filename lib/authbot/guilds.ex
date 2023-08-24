defmodule Authbot.Guilds do
  @moduledoc """
  The Guilds context.
  """

  import Ecto.Query, warn: false
  alias Authbot.Repo

  alias Authbot.Guilds.Config
  alias Authbot.Guilds.AssignableRole

  def get_verified_role(guild_id) do
    config = get_config_by_guild_id(guild_id)
    config.verified_role_id
  end

  def get_config_by_guild_id(guild_id) do
    Repo.get_by(Config, guild_id: guild_id)
  end

  def create_guild_config(guild_id) do
    %Config{}
    |> Config.changeset(%{guild_id: guild_id})
    |> Repo.insert()
  end

  def update_config(%Config{} = config, attrs) do
    config
    |> Config.changeset(attrs)
    |> Repo.update()
  end

  def add_guild_assignable_role(guild_id, role_id, name) do
    %AssignableRole{}
    |> AssignableRole.changeset(%{guild_id: guild_id, role_id: role_id, name: name})
    |> Repo.insert()
  end

  def remove_guild_assignable_role(guild_id, role_id) do
    AssignableRole
    |> where(guild_id: ^guild_id)
    |> where(role_id: ^role_id)
    |> Repo.delete_all
  end

  def list_guild_assignable_roles(guild_id) do
    AssignableRole
    |> where(guild_id: ^guild_id)
    |> Repo.all
  end
end
