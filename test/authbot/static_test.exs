defmodule Authbot.StaticTest do
  use Authbot.DataCase

  alias Authbot.Static

  describe "goon_primary_groups" do
    alias Authbot.Static.GoonPrimaryGroup

    import Authbot.StaticFixtures

    @invalid_attrs %{name: nil, ticker: nil, primary_group: nil}

    test "list_goon_primary_groups/0 returns all goon_primary_groups" do
      goon_primary_group = goon_primary_group_fixture()
      assert Static.list_goon_primary_groups() == [goon_primary_group]
    end

    test "get_goon_primary_group!/1 returns the goon_primary_group with given id" do
      goon_primary_group = goon_primary_group_fixture()
      assert Static.get_goon_primary_group!(goon_primary_group.id) == goon_primary_group
    end

    test "create_goon_primary_group/1 with valid data creates a goon_primary_group" do
      valid_attrs = %{name: "some name", ticker: "some ticker", primary_group: 42}

      assert {:ok, %GoonPrimaryGroup{} = goon_primary_group} = Static.create_goon_primary_group(valid_attrs)
      assert goon_primary_group.name == "some name"
      assert goon_primary_group.ticker == "some ticker"
      assert goon_primary_group.primary_group == 42
    end

    test "create_goon_primary_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Static.create_goon_primary_group(@invalid_attrs)
    end

    test "update_goon_primary_group/2 with valid data updates the goon_primary_group" do
      goon_primary_group = goon_primary_group_fixture()
      update_attrs = %{name: "some updated name", ticker: "some updated ticker", primary_group: 43}

      assert {:ok, %GoonPrimaryGroup{} = goon_primary_group} = Static.update_goon_primary_group(goon_primary_group, update_attrs)
      assert goon_primary_group.name == "some updated name"
      assert goon_primary_group.ticker == "some updated ticker"
      assert goon_primary_group.primary_group == 43
    end

    test "update_goon_primary_group/2 with invalid data returns error changeset" do
      goon_primary_group = goon_primary_group_fixture()
      assert {:error, %Ecto.Changeset{}} = Static.update_goon_primary_group(goon_primary_group, @invalid_attrs)
      assert goon_primary_group == Static.get_goon_primary_group!(goon_primary_group.id)
    end

    test "delete_goon_primary_group/1 deletes the goon_primary_group" do
      goon_primary_group = goon_primary_group_fixture()
      assert {:ok, %GoonPrimaryGroup{}} = Static.delete_goon_primary_group(goon_primary_group)
      assert_raise Ecto.NoResultsError, fn -> Static.get_goon_primary_group!(goon_primary_group.id) end
    end

    test "change_goon_primary_group/1 returns a goon_primary_group changeset" do
      goon_primary_group = goon_primary_group_fixture()
      assert %Ecto.Changeset{} = Static.change_goon_primary_group(goon_primary_group)
    end
  end
end
