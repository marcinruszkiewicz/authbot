defmodule Authbot.Repo.Migrations.CreateAssignableRoles do
  use Ecto.Migration

  def change do
    create table(:assignable_roles) do
      add :guild_id, :bigint
      add :role_id, :bigint
      add :name, :string

      timestamps()
    end
  end
end
