defmodule Authbot.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: Authbot.Repo
  use Authbot.GoonPrimaryGroupFactory
  use Authbot.AssignableRoleFactory
  use Authbot.ConfigFactory
end
