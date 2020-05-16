use Mix.Config

# Configure your database
config :plangora, Plangora.Repo,
  username: "postgres",
  password: "postgres",
  database: "plangora_test",
  hostname: System.get_env("DB_SERVER") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :plangora, PlangoraWeb.Endpoint,
  http: [port: 4002],
  server: false

config :bcrypt_elixir, :log_rounds, 4

# Print only warnings and errors during test
config :logger, level: :warn
