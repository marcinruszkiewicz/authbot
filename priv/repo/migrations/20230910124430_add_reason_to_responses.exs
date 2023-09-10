defmodule Authbot.Repo.Migrations.AddReasonToResponses do
  use Ecto.Migration

  def change do
    alter table(:responses) do
      add :reason, :string
    end
  end
end
