# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :plangora,
  ecto_repos: [Plangora.Repo]

# Configures the endpoint
config :plangora, PlangoraWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "z6get1P3oOfGkG6dQACp6odL7d5QxWdx/AaW/RhtRy+CcwY2s8xg/fFpWoPuYt6+",
  render_errors: [view: PlangoraWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Plangora.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "Z5ccOj3BgZv6oCdqW4pQc9hl6MHBGufX"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :plangora, env: Mix.env()

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
