defmodule AuthbotWeb.PageControllerTest do
  use AuthbotWeb.ConnCase, async: true

  describe "GET /" do
    test "shows the landing page", %{conn: conn} do
      conn = get(conn, ~p"/")

      response = html_response(conn, 200)
      assert response =~ "Go to discord and follow an auth link from there."
    end
  end

  describe "GET /finished" do
    test "shows the finished page", %{conn: conn} do
      conn = get(conn, ~p"/finished")

      response = html_response(conn, 200)
      assert response =~ "Your authorization is done. Your Discord role and nick on the GSF AT server should have been updated."
    end
  end

  describe "GET /step1" do
    test "shows the step1 page", %{conn: conn} do
      conn = get(conn, ~p"/12345/step1")

      response = html_response(conn, 200)
      assert response =~ "Login to Discord to start your authorization."
    end
  end

  describe "GET /step2" do
    test "shows the step2 page", %{conn: conn} do
      conn =
        conn
        |> Phoenix.ConnTest.init_test_session(%{})
        |> Plug.Conn.put_session(:discord_name, "TestDiscordUser")
        |> get(~p"/step2")

      response = html_response(conn, 200)
      assert response =~ "You've logged into Discord as TestDiscordUser. Now login into Goonfleet with your forums account:"
    end
  end
end
