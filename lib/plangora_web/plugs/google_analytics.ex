defmodule PlangoraWeb.GoogleAnalytics do
  import Plug.Conn, only: [assign: 3]

  def init(opts), do: Keyword.put(opts, :env, Application.get_env(:plangora, :env))

  def call(conn, env: :prod),
    do: assign(conn, :google_analytics_id, Application.get_env(:plangora, :google_analytics_id))

  def call(conn, _opts), do: conn
end
