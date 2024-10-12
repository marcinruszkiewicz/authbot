defmodule Authbot.Static.GoonPrimaryGroup do
  @moduledoc false
  use Ecto.Schema

  schema "goon_primary_groups" do
    field(:name, :string)
    field(:ticker, :string)
    field(:primary_group, :integer)

    timestamps()
  end
end
