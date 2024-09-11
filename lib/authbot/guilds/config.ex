defmodule Authbot.Guilds.Config do
  use Ecto.Schema
  import Ecto.Changeset

  schema "configs" do
    field :guild_id, :integer
    field :verified_role_id, :integer
    field :gsf_role_id, :integer
    field :ally_role_id, :integer
    field :alliance_tag, :boolean

    timestamps()
  end

  @doc false
  def changeset(config, attrs) do
    config
    |> cast(attrs, [:guild_id, :verified_role_id, :gsf_role_id, :ally_role_id, :alliance_tag])
    |> validate_required([:guild_id])
    |> unique_constraint(:guild_id)
  end
end
