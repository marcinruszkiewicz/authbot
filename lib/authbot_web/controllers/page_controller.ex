defmodule AuthbotWeb.PageController do
  use AuthbotWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def step1(conn, %{"guild_id" => guild_id}) do
    conn
    |> put_session(:guild_id, guild_id)
    |> render(:step1)
  end

  def step2(conn, _params) do
    discord_name = get_session(conn, :discord_name)

    render(conn, :step2, discord_name: discord_name)
  end

  def finished(conn, _params) do
    render(conn, :finished)
  end
end
