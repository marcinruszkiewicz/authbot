defmodule Authbot.Debug do
  @moduledoc """
  The Debug context.
  """

  import Ecto.Query, warn: false
  alias Authbot.Repo

  alias Authbot.Debug.Response

  def log_response(data, reason) do
    %Response{}
    |> Response.changeset(%{data: data, reason: reason})
    |> Repo.insert()
  end
end
