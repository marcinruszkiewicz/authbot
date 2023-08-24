defmodule Authbot.Repo.Migrations.CreateConfigs do
  use Ecto.Migration

  def change do
    create table(:configs) do
      add :guild_id, :bigint
      add :verified_role_id, :bigint
      add :gsf_role_id, :bigint
      add :ally_role_id, :bigint

      timestamps()
    end
  end
end
