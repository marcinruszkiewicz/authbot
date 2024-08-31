defmodule Authbot.DebugTest do
  use Authbot.DataCase

  alias Authbot.Debug
  alias Authbot.Debug.Response

  test "log_response/2 with valid data creates a response" do
    assert {:ok, %Response{} = response} = Debug.log_response("some data", "log reason")
    assert response.data == "some data"
  end

  test "log_response/2 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Debug.log_response(nil, "log reason")
  end
end
