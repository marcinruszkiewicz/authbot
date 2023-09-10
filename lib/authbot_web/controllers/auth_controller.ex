defmodule AuthbotWeb.AuthController do
  use AuthbotWeb, :controller
  plug Ueberauth

  alias Authbot.Guilds
  alias Authbot.Debug
  alias Authbot.Static

  def callback(conn, %{"provider" => "discord" }) do
    {member_id, _} = Integer.parse(conn.assigns.ueberauth_auth.uid)

    conn
    |> put_session(:member_id, member_id)
    |> put_session(:discord_name, conn.assigns.ueberauth_auth.info.nickname)
    |> redirect(to: ~p"/step2")
  end

  def callback(conn, %{"provider" => "goonfleet" }) do
    conn.assigns.ueberauth_auth
    |> Kernel.inspect
    |> Debug.log_response("goonfleet")

    guild_id = conn |> get_session(:guild_id)
    member_id = conn |> get_session(:member_id)

    role_id = determine_role_id(guild_id, conn.assigns.ueberauth_auth.info.location)
    new_nick = determine_new_nickname(conn.assigns.ueberauth_auth.info.location, conn.assigns.ueberauth_auth.info.name)

    Authbot.BotConsumer.give_role(guild_id, member_id, role_id)
    Authbot.BotConsumer.change_nickname(guild_id, member_id, new_nick)

    conn
    |> redirect(to: ~p"/finished")
  end

  defp determine_role_id(guild_id, primary_group) do
    case Static.get_primary_group(primary_group) do
      nil -> Guilds.get_gsf_role(guild_id)
      _ -> Guilds.get_ally_role(guild_id)
    end
  end

  defp determine_new_nickname(primary_group, forum_name) do
    ticker =
      case Static.get_primary_group(primary_group) do
        nil -> "[CONDI]"
        ally -> ally.ticker
      end

    ticker <> " " <> forum_name
  end
  # defp determine_role_id(guild_id, _), do: Guilds.get_verified_role(guild_id)
end
