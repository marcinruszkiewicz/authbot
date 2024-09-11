defmodule Authbot.Repo.Migrations.AddAllianceTagToConfig do
  use Ecto.Migration

  def change do
    alter table(:configs) do
      add :alliance_tag, :boolean, default: true, null: false
    end
  end
end
