defmodule Authbot.Repo.Migrations.UniqueConstraints do
  use Ecto.Migration

  def change do
    create unique_index(:configs, :guild_id)
  end
end
