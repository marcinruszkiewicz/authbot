defmodule Authbot.StaticTest do
  use Authbot.DataCase
  import Authbot.Factory

  alias Authbot.Static

  test "get_primary_group/1 returns the goon_primary_group with given id" do
    test_group = insert(:goon_primary_group, primary_group: 777, name: "Test Group", ticker: "TEST")

    assert Static.get_primary_group(test_group.primary_group) == test_group
  end
end
