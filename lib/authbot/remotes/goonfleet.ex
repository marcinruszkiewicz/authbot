defmodule Authbot.Remotes.Goonfleet do
  use HTTPoison.Base

  def process_request_url(url) do
    "https://esi.goonfleet.com" <> url
  end

  def process_response_body(body) do
    body
    |> IO.inspect
    |> Jason.decode!
    |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)
  end
end
