defmodule Authbot.Static.GoonPrimaryGroup do
  use Ecto.Schema
  import Ecto.Changeset

  schema "goon_primary_groups" do
    field :name, :string
    field :ticker, :string
    field :primary_group, :integer

    timestamps()
  end

  @doc false
  def changeset(goon_primary_group, attrs) do
    goon_primary_group
    |> cast(attrs, [:primary_group, :name, :ticker])
  end
end
