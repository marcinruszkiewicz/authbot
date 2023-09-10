defmodule Authbot.DebugTest do
  use Authbot.DataCase

  alias Authbot.Debug

  describe "responses" do
    alias Authbot.Debug.Response

    import Authbot.DebugFixtures

    @invalid_attrs %{data: nil}

    test "list_responses/0 returns all responses" do
      response = response_fixture()
      assert Debug.list_responses() == [response]
    end

    test "get_response!/1 returns the response with given id" do
      response = response_fixture()
      assert Debug.get_response!(response.id) == response
    end

    test "create_response/1 with valid data creates a response" do
      valid_attrs = %{data: "some data"}

      assert {:ok, %Response{} = response} = Debug.create_response(valid_attrs)
      assert response.data == "some data"
    end

    test "create_response/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Debug.create_response(@invalid_attrs)
    end

    test "update_response/2 with valid data updates the response" do
      response = response_fixture()
      update_attrs = %{data: "some updated data"}

      assert {:ok, %Response{} = response} = Debug.update_response(response, update_attrs)
      assert response.data == "some updated data"
    end

    test "update_response/2 with invalid data returns error changeset" do
      response = response_fixture()
      assert {:error, %Ecto.Changeset{}} = Debug.update_response(response, @invalid_attrs)
      assert response == Debug.get_response!(response.id)
    end

    test "delete_response/1 deletes the response" do
      response = response_fixture()
      assert {:ok, %Response{}} = Debug.delete_response(response)
      assert_raise Ecto.NoResultsError, fn -> Debug.get_response!(response.id) end
    end

    test "change_response/1 returns a response changeset" do
      response = response_fixture()
      assert %Ecto.Changeset{} = Debug.change_response(response)
    end
  end
end
