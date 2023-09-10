defmodule Authbot.Repo.Migrations.CreateResponses do
  use Ecto.Migration

  def change do
    create table(:responses) do
      add :data, :text

      timestamps()
    end
  end
end
