import Config

config :authbot, Authbot.Repo,
  username: "skyace",
  password: "",
  hostname: "localhost",
  database: "authbot_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :authbot, AuthbotWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "CtxhkT1bz8wJ8L63GGZi9pEbbGJAoBTJapEYxAY8egYmsKdqnOzTyNJ1DE+VDTji",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
