defmodule Authbot.Factory do
  use ExMachina.Ecto, repo: Authbot.Repo

  use Authbot.GoonPrimaryGroupFactory
end
