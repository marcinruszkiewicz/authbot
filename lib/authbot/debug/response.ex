defmodule Authbot.Debug.Response do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "responses" do
    field(:data, :string)
    field(:reason, :string)

    timestamps()
  end

  @doc false
  def changeset(response, attrs) do
    response
    |> cast(attrs, [:data, :reason])
    |> validate_required([:data])
  end
end
