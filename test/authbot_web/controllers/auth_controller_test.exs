defmodule AuthbotWeb.AuthControllerTest do
  use AuthbotWeb.ConnCase, async: true
  use Authbot.DataCase

  import Authbot.Factory
  import Mock

  alias Ueberauth.Auth.Info

  describe "discord oauth callback" do
    test "saves name and discord user id and redirects to next step", %{conn: conn} do
      conn =
        conn
        |> assign(:ueberauth_auth, %Ueberauth.Auth{
          uid: "12345678",
          info: %Info{
            nickname: "TestDiscordUser"
          }
        })
        |> get(~p"/auth/discord/callback")

      assert redirected_to(conn) == ~p"/step2"
      assert get_session(conn, :member_id) == 12_345_678
      assert get_session(conn, :discord_name) == "TestDiscordUser"
    end
  end

  describe "goonfleet oauth callback" do
    test "renames GSF user with ticker and redirects to next step", %{conn: conn} do
      insert(:config, guild_id: 12_345, gsf_role_id: 12, ally_role_id: 234, verified_role_id: 567, alliance_ticker: true)

      with_mocks([
        {
          Authbot.BotConsumer,
          [],
          [
            give_role: fn _guild_id, _member_id, _role_id -> nil end,
            change_nickname: fn _guild_id, _member_id, _new_nick -> nil end
          ]
        }
      ]) do
        conn =
          conn
          |> assign(:ueberauth_auth, %Ueberauth.Auth{
            uid: "12345678",
            info: %Info{
              name: "TestGSFUser",
              location: "550"
            }
          })
          |> Phoenix.ConnTest.init_test_session(%{})
          |> Plug.Conn.put_session(:guild_id, 12_345)
          |> Plug.Conn.put_session(:member_id, 9876)
          |> get(~p"/auth/goonfleet/callback")

        assert_called(Authbot.BotConsumer.give_role(12_345, 9876, 12))
        assert_called(Authbot.BotConsumer.change_nickname(12_345, 9876, "[CONDI] TestGSFUser"))
        assert redirected_to(conn) == ~p"/finished"
      end
    end

    test "renames GSF user without ticker and redirects to next step", %{conn: conn} do
      insert(:config, guild_id: 12_345, gsf_role_id: 12, ally_role_id: 234, verified_role_id: 567, alliance_ticker: false)

      with_mocks([
        {
          Authbot.BotConsumer,
          [],
          [
            give_role: fn _guild_id, _member_id, _role_id -> nil end,
            change_nickname: fn _guild_id, _member_id, _new_nick -> nil end
          ]
        }
      ]) do
        conn =
          conn
          |> assign(:ueberauth_auth, %Ueberauth.Auth{
            uid: "12345678",
            info: %Info{
              name: "TestGSFUser",
              location: "550"
            }
          })
          |> Phoenix.ConnTest.init_test_session(%{})
          |> Plug.Conn.put_session(:guild_id, 12_345)
          |> Plug.Conn.put_session(:member_id, 9876)
          |> get(~p"/auth/goonfleet/callback")

        assert_called(Authbot.BotConsumer.give_role(12_345, 9876, 12))
        assert_called(Authbot.BotConsumer.change_nickname(12_345, 9876, "TestGSFUser"))
        assert redirected_to(conn) == ~p"/finished"
      end
    end

    test "renames ally user with ticker and redirects to next step", %{conn: conn} do
      insert(:config, guild_id: 12_345, gsf_role_id: 12, ally_role_id: 234, verified_role_id: 567, alliance_ticker: true)
      insert(:goon_primary_group, name: "Sigma", ticker: "[5IGMA]", primary_group: 1353)

      with_mocks([
        {
          Authbot.BotConsumer,
          [],
          [
            give_role: fn _guild_id, _member_id, _role_id -> nil end,
            change_nickname: fn _guild_id, _member_id, _new_nick -> nil end
          ]
        }
      ]) do
        conn =
          conn
          |> assign(:ueberauth_auth, %Ueberauth.Auth{
            uid: "12345678",
            info: %Info{
              name: "TestSigmaUser",
              location: "1353"
            }
          })
          |> Phoenix.ConnTest.init_test_session(%{})
          |> Plug.Conn.put_session(:guild_id, 12_345)
          |> Plug.Conn.put_session(:member_id, 9876)
          |> get(~p"/auth/goonfleet/callback")

        assert_called(Authbot.BotConsumer.give_role(12_345, 9876, 234))
        assert_called(Authbot.BotConsumer.change_nickname(12_345, 9876, "[5IGMA] TestSigmaUser"))
        assert redirected_to(conn) == ~p"/finished"
      end
    end
  end
end
