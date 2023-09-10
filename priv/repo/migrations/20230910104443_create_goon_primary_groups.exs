defmodule Authbot.Repo.Migrations.CreateGoonPrimaryGroups do
  use Ecto.Migration

  def change do
    create table(:goon_primary_groups) do
      add :primary_group, :integer
      add :name, :string
      add :ticker, :string

      timestamps()
    end
  end
end
