# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :authbot,
  ecto_repos: [Authbot.Repo]

# Configures the endpoint
config :authbot, AuthbotWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: AuthbotWeb.ErrorHTML, json: AuthbotWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Authbot.PubSub,
  live_view: [signing_salt: "M5OMlc6/"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.7",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  providers: [
    discord: {Ueberauth.Strategy.Discord, []},
    goonfleet: {Ueberauth.Strategy.Goonfleet, []}
  ]

config :ueberauth, Ueberauth.Strategy.Discord.OAuth,
  client_id: System.get_env("AUTHBOT_DISCORD_CLIENT_ID"),
  client_secret: System.get_env("AUTHBOT_DISCORD_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Goonfleet.OAuth,
  client_id: System.get_env("AUTHBOT_GOONFLEET_CLIENT_ID"),
  client_secret: System.get_env("AUTHBOT_GOONFLEET_CLIENT_SECRET")

config :nostrum,
  token: System.get_env("AUTHBOT_BOT_TOKEN"),
  gateway_intents: [
    :direct_messages,
    :guild_bans,
    :guild_members,
    :guild_message_reactions,
    :guild_messages,
    :guilds,
    :message_content
  ]

config :authbot,
  guild_id: System.get_env("AUTHBOT_DISCORD_GUILD_ID"),
  gsf_role: System.get_env("AUTHBOT_DISCORD_GSF_ROLE_ID"),
  ally_role: System.get_env("AUTHBOT_DISCORD_ALLY_ROLE_ID"),
  verified_role: System.get_env("AUTHBOT_DISCORD_VERIFIED_ROLE_ID")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
