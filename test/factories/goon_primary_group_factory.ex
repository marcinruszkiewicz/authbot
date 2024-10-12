defmodule Authbot.GoonPrimaryGroupFactory do
  @moduledoc false
  alias Authbot.Static.GoonPrimaryGroup

  defmacro __using__(_opts) do
    quote do
      def goon_primary_group_factory do
        %GoonPrimaryGroup{
          name: "Goonswarm Federation",
          ticker: "CONDI",
          primary_group: 1234
        }
      end
    end
  end
end
