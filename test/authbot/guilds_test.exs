defmodule Authbot.GuildsTest do
  use Authbot.DataCase

  import Authbot.Factory

  alias Authbot.Guilds
  alias Authbot.Guilds.AssignableRole
  alias Authbot.Guilds.Config

  @invalid_guild_attrs %{guild_id: nil, verified_role_id: nil, gsf_role_id: nil, ally_role_id: nil, alliance_ticker: nil}

  test "get_verified_role/1 returns the proper role for the proper guild" do
    insert(:config, guild_id: 123, verified_role_id: 15)
    insert(:config, guild_id: 333, verified_role_id: 33)

    assert Guilds.get_verified_role(123) == 15
  end

  test "get_ally_role/1 returns the proper role for the proper guild" do
    insert(:config, guild_id: 123, ally_role_id: 15)
    insert(:config, guild_id: 333, ally_role_id: 33)

    assert Guilds.get_ally_role(123) == 15
  end

  test "get_gsf_role/1 returns the proper role for the proper guild" do
    insert(:config, guild_id: 123, gsf_role_id: 15)
    insert(:config, guild_id: 333, gsf_role_id: 33)

    assert Guilds.get_gsf_role(123) == 15
  end

  test "add_alliance_ticker?/1 returns configured bool" do
    insert(:config, guild_id: 123, alliance_ticker: true)
    insert(:config, guild_id: 23, alliance_ticker: false)

    assert Guilds.add_alliance_ticker?(123) == true
    assert Guilds.add_alliance_ticker?(23) == false
  end

  test "get_config_by_guild_id/1 returns the config with given id" do
    config = insert(:config, guild_id: 123, gsf_role_id: 15)
    assert Guilds.get_config_by_guild_id(123) == config
  end

  test "create_guild_config/1 with valid data creates a config" do
    assert {:ok, %Config{} = config} = Guilds.create_guild_config(42)
    assert config.guild_id == 42
    assert config.verified_role_id == nil
    assert config.gsf_role_id == nil
    assert config.ally_role_id == nil
  end

  test "create_guild_config/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Guilds.create_guild_config(@invalid_guild_attrs)
  end

  test "update_config/2 with valid data updates the config" do
    config = insert(:config, guild_id: 123, gsf_role_id: 15)
    update_attrs = %{guild_id: 43, verified_role_id: 43, gsf_role_id: 43, ally_role_id: 43}

    assert {:ok, %Config{} = config} = Guilds.update_config(config, update_attrs)
    assert config.guild_id == 43
    assert config.verified_role_id == 43
    assert config.gsf_role_id == 43
    assert config.ally_role_id == 43
  end

  test "update_config/2 with invalid data returns error changeset" do
    config = insert(:config, guild_id: 123, gsf_role_id: 15)
    assert {:error, %Ecto.Changeset{}} = Guilds.update_config(config, @invalid_guild_attrs)
    assert config == Guilds.get_config_by_guild_id(config.guild_id)
  end

  test "list_guild_assignable_roles/1 returns all assignable_roles" do
    assignable_role = insert(:assignable_role, guild_id: 123)
    assert Guilds.list_guild_assignable_roles(123) == [assignable_role]
  end

  test "add_guild_assignable_role/2 with valid data creates a assignable_role" do
    assert {:ok, %AssignableRole{} = assignable_role} = Guilds.add_guild_assignable_role(42, 42, "some name")
    assert assignable_role.name == "some name"
    assert assignable_role.guild_id == 42
    assert assignable_role.role_id == 42
  end

  test "add_guild_assignable_role/2 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Guilds.add_guild_assignable_role(42, nil, nil)
  end

  test "remove_guild_assignable_role/1 deletes the assignable_role" do
    insert(:assignable_role, guild_id: 42, role_id: 44)

    Guilds.remove_guild_assignable_role(42, 44)
    assert Guilds.list_guild_assignable_roles(42) == []
  end
end
