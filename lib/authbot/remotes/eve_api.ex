defmodule Authbot.Remotes.EveApi do
  @moduledoc false
  use HTTPoison.Base

  def process_request_url(url) do
    "https://esi.evetech.net/latest" <> url
  end

  def process_response_body(body) do
    body
    |> Jason.decode!()
    |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
  end
end
