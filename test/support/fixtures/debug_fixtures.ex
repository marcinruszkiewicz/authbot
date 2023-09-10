defmodule Authbot.DebugFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Authbot.Debug` context.
  """

  @doc """
  Generate a response.
  """
  def response_fixture(attrs \\ %{}) do
    {:ok, response} =
      attrs
      |> Enum.into(%{
        data: "some data"
      })
      |> Authbot.Debug.create_response()

    response
  end
end
