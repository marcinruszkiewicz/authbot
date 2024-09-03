defmodule Authbot.ConfigFactory do
  alias Authbot.Guilds.Config

  defmacro __using__(_opts) do
    quote do
      def config_factory do
        %Config{
          guild_id: 1234,
          verified_role_id: 1,
          gsf_role_id: 2,
          ally_role_id: 3
        }
      end
    end
  end
end
