defmodule Authbot.AssignableRoleFactory do
  @moduledoc false
  alias Authbot.Guilds.AssignableRole

  defmacro __using__(_opts) do
    quote do
      def assignable_role_factory do
        %AssignableRole{
          name: "Logi",
          guild_id: 1234,
          role_id: 5
        }
      end
    end
  end
end
