defmodule AuthbotWeb.PageController do
  use AuthbotWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def step2(conn, _params) do
    discord_name = conn |> get_session(:discord_name)

    render(conn, :step2, discord_name: discord_name)
  end

  def finished(conn, _params) do
    render(conn, :finished)
  end
end
