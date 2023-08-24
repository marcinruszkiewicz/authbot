defmodule Authbot.Repo do
  use Ecto.Repo,
    otp_app: :authbot,
    adapter: Ecto.Adapters.Postgres
end
