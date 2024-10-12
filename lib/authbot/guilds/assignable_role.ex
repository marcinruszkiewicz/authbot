defmodule Authbot.Guilds.AssignableRole do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "assignable_roles" do
    field(:name, :string)
    field(:guild_id, :integer)
    field(:role_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(assignable_role, attrs) do
    assignable_role
    |> cast(attrs, [:guild_id, :role_id, :name])
    |> validate_required([:guild_id, :role_id, :name])
  end
end
