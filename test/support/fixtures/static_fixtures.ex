defmodule Authbot.StaticFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Authbot.Static` context.
  """

  @doc """
  Generate a goon_primary_group.
  """
  def goon_primary_group_fixture(attrs \\ %{}) do
    {:ok, goon_primary_group} =
      attrs
      |> Enum.into(%{
        name: "some name",
        ticker: "some ticker",
        primary_group: 42
      })
      |> Authbot.Static.create_goon_primary_group()

    goon_primary_group
  end
end
