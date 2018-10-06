# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :stormchat,
  ecto_repos: [Stormchat.Repo]

# Configure Google OAuth
config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [default_scope: "emails profile plus.me"]}
  ]
config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

# Configures the endpoint
config :stormchat, StormchatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dSyVRaallrllHLz89jyXCnWDJTo6iMYpmIdbti9i0DC8lCrfMlHkNw772IyGEDIQ",
  render_errors: [view: StormchatWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Stormchat.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# mailgun config
config :stormchat, mailgun_domain: "https://api.mailgun.net/v3/mg.stormchat.sushiparty.blog",
                   mailgun_key: "key-8af49ae9fbef0d74143a86e4f34d4fe4"
