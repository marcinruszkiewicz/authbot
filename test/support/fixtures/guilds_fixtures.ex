defmodule Authbot.GuildsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Authbot.Guilds` context.
  """

  @doc """
  Generate a config.
  """
  def config_fixture(attrs \\ %{}) do
    {:ok, config} =
      attrs
      |> Enum.into(%{
        guild_id: 42,
        verified_role_id: 42,
        gsf_role_id: 42,
        ally_role_id: 42
      })
      |> Authbot.Guilds.create_config()

    config
  end

  @doc """
  Generate a assignable_role.
  """
  def assignable_role_fixture(attrs \\ %{}) do
    {:ok, assignable_role} =
      attrs
      |> Enum.into(%{
        name: "some name",
        guild_id: 42,
        role_id: 42
      })
      |> Authbot.Guilds.create_assignable_role()

    assignable_role
  end
end
