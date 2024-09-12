defmodule Authbot.Remotes.GoonfleetTest do
  use Authbot.DataCase
  import Assertions

  alias Authbot.Remotes.Goonfleet

  describe "process_request_url/1" do
    test "adds query to BN url" do
      query = "/status/?datasource=tranquility"

      assert "https://esi.goonfleet.com/status/?datasource=tranquility" ==
        Goonfleet.process_request_url(query)
    end
  end

  describe "process_request_body/1" do
    test "decodes json data" do
      test_json = File.read!(Path.expand("../../support/fixtures/status.json", __DIR__)) |> Jason.decode!

      assert_structs_equal %{"players" => 18887}, Goonfleet.process_request_body(test_json), ["players"]
    end
  end
end
