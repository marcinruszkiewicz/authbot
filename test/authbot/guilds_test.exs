# defmodule Authbot.GuildsTest do
#   use Authbot.DataCase

#   alias Authbot.Guilds

#   describe "configs" do
#     alias Authbot.Guilds.Config

#     @invalid_attrs %{guild_id: nil, verified_role_id: nil, gsf_role_id: nil, ally_role_id: nil}

#     test "list_configs/0 returns all configs" do
#       config = config_fixture()
#       assert Guilds.list_configs() == [config]
#     end

#     test "get_config!/1 returns the config with given id" do
#       config = config_fixture()
#       assert Guilds.get_config!(config.id) == config
#     end

#     test "create_config/1 with valid data creates a config" do
#       valid_attrs = %{guild_id: 42, verified_role_id: 42, gsf_role_id: 42, ally_role_id: 42}

#       assert {:ok, %Config{} = config} = Guilds.create_config(valid_attrs)
#       assert config.guild_id == 42
#       assert config.verified_role_id == 42
#       assert config.gsf_role_id == 42
#       assert config.ally_role_id == 42
#     end

#     test "create_config/1 with invalid data returns error changeset" do
#       assert {:error, %Ecto.Changeset{}} = Guilds.create_config(@invalid_attrs)
#     end

#     test "update_config/2 with valid data updates the config" do
#       config = config_fixture()
#       update_attrs = %{guild_id: 43, verified_role_id: 43, gsf_role_id: 43, ally_role_id: 43}

#       assert {:ok, %Config{} = config} = Guilds.update_config(config, update_attrs)
#       assert config.guild_id == 43
#       assert config.verified_role_id == 43
#       assert config.gsf_role_id == 43
#       assert config.ally_role_id == 43
#     end

#     test "update_config/2 with invalid data returns error changeset" do
#       config = config_fixture()
#       assert {:error, %Ecto.Changeset{}} = Guilds.update_config(config, @invalid_attrs)
#       assert config == Guilds.get_config!(config.id)
#     end

#     test "delete_config/1 deletes the config" do
#       config = config_fixture()
#       assert {:ok, %Config{}} = Guilds.delete_config(config)
#       assert_raise Ecto.NoResultsError, fn -> Guilds.get_config!(config.id) end
#     end

#     test "change_config/1 returns a config changeset" do
#       config = config_fixture()
#       assert %Ecto.Changeset{} = Guilds.change_config(config)
#     end
#   end

#   describe "assignable_roles" do
#     alias Authbot.Guilds.AssignableRole

#     import Authbot.GuildsFixtures

#     @invalid_attrs %{name: nil, guild_id: nil, role_id: nil}

#     test "list_assignable_roles/0 returns all assignable_roles" do
#       assignable_role = assignable_role_fixture()
#       assert Guilds.list_assignable_roles() == [assignable_role]
#     end

#     test "get_assignable_role!/1 returns the assignable_role with given id" do
#       assignable_role = assignable_role_fixture()
#       assert Guilds.get_assignable_role!(assignable_role.id) == assignable_role
#     end

#     test "create_assignable_role/1 with valid data creates a assignable_role" do
#       valid_attrs = %{name: "some name", guild_id: 42, role_id: 42}

#       assert {:ok, %AssignableRole{} = assignable_role} = Guilds.create_assignable_role(valid_attrs)
#       assert assignable_role.name == "some name"
#       assert assignable_role.guild_id == 42
#       assert assignable_role.role_id == 42
#     end

#     test "create_assignable_role/1 with invalid data returns error changeset" do
#       assert {:error, %Ecto.Changeset{}} = Guilds.create_assignable_role(@invalid_attrs)
#     end

#     test "update_assignable_role/2 with valid data updates the assignable_role" do
#       assignable_role = assignable_role_fixture()
#       update_attrs = %{name: "some updated name", guild_id: 43, role_id: 43}

#       assert {:ok, %AssignableRole{} = assignable_role} = Guilds.update_assignable_role(assignable_role, update_attrs)
#       assert assignable_role.name == "some updated name"
#       assert assignable_role.guild_id == 43
#       assert assignable_role.role_id == 43
#     end

#     test "update_assignable_role/2 with invalid data returns error changeset" do
#       assignable_role = assignable_role_fixture()
#       assert {:error, %Ecto.Changeset{}} = Guilds.update_assignable_role(assignable_role, @invalid_attrs)
#       assert assignable_role == Guilds.get_assignable_role!(assignable_role.id)
#     end

#     test "delete_assignable_role/1 deletes the assignable_role" do
#       assignable_role = assignable_role_fixture()
#       assert {:ok, %AssignableRole{}} = Guilds.delete_assignable_role(assignable_role)
#       assert_raise Ecto.NoResultsError, fn -> Guilds.get_assignable_role!(assignable_role.id) end
#     end

#     test "change_assignable_role/1 returns a assignable_role changeset" do
#       assignable_role = assignable_role_fixture()
#       assert %Ecto.Changeset{} = Guilds.change_assignable_role(assignable_role)
#     end
#   end
# end
