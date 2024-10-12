defmodule Authbot.Static do
  @moduledoc """
  The Static context.
  """

  import Ecto.Query, warn: false

  alias Authbot.Repo
  alias Authbot.Static.GoonPrimaryGroup

  def get_primary_group(primary_group) do
    Repo.get_by(GoonPrimaryGroup, primary_group: primary_group)
  end
end
