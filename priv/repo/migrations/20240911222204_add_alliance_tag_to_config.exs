defmodule Authbot.Repo.Migrations.AddAllianceTagToConfig do
  use Ecto.Migration

  def change do
    alter table(:configs) do
      add :alliance_ticker, :boolean, default: true, null: false
    end
  end
end
