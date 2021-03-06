use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :stormchat, StormchatWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :stormchat, Stormchat.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "stormchat",
  password: "eik0ooY7ugho",
  database: "stormchat_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
