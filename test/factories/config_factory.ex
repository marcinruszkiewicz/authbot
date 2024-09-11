defmodule Authbot.ConfigFactory do
  alias Authbot.Guilds.Config

  defmacro __using__(_opts) do
    quote do
      def config_factory do
        %Config{
          guild_id: 1234,
          verified_role_id: 1,
          gsf_role_id: 2,
          ally_role_id: 3,
          alliance_ticker: true
        }
      end
    end
  end
end
