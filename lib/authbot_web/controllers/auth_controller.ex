defmodule AuthbotWeb.AuthController do
  use AuthbotWeb, :controller
  plug Ueberauth

  alias Authbot.Guilds

  def callback(conn, %{"provider" => "discord" }) do
    {member_id, _} = Integer.parse(conn.assigns.ueberauth_auth.uid)

    conn
    |> put_session(:member_id, member_id)
    |> put_session(:discord_name, conn.assigns.ueberauth_auth.info.nickname)
    |> redirect(to: ~p"/step2")
  end

  def callback(conn, %{"provider" => "goonfleet" }) do
    guild_id = conn |> get_session(:guild_id)
    member_id = conn |> get_session(:member_id)

    role_id = determine_role_id(guild_id, conn.assigns.ueberauth_auth.info.location)

    Authbot.BotConsumer.give_role(guild_id, member_id, role_id)

    conn
    |> redirect(to: ~p"/finished")
  end

  defp determine_role_id(guild_id, _), do: Guilds.get_verified_role(guild_id)
  # defp determine_role_id(primary_group) do
  #   Authbot.Remotes.Goonfleet.start

  #   path = "/Api/Group/" <> primary_group <> "/Name"
  #   username = Application.get_env(:ueberauth, Ueberauth.Strategy.Goonfleet.OAuth)[:client_id]
  #   password = Application.get_env(:ueberauth, Ueberauth.Strategy.Goonfleet.OAuth)[:client_secret]
  #   header_content = "Basic " <> Base.encode64("#{username}:#{password}")

  #   header = [
  #     {"Authorization", header_content}
  #   ]

  #   IO.inspect Authbot.Remotes.Goonfleet.get!(path, header)

  #   Application.get_env(:authbot, :gsf_role)
  # end
end
