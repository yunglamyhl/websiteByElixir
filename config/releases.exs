import Config

config :plangora, PlangoraWeb.Endpoint, secret_key_base: System.get_env("SECRET_KEY_BASE")

config :plangora, google_analytics_id: System.get_env("GA_ID")
