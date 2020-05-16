defmodule PlangoraWeb.Locale do
  import Plug.Conn, only: [put_session: 3, get_session: 2, assign: 3]

  @locales ["en", "zh"]

  def init(opts), do: opts

  def call(%Plug.Conn{params: %{"locale" => locale}} = conn, _opts) when locale in @locales do
    setup_locale(conn, locale)
  end

  def call(conn, _opts) do
    case get_session(conn, "locale") do
      nil ->
        setup_locale(conn, "en")

      locale ->
        setup_locale(conn, locale)
    end
  end

  defp setup_locale(conn, locale) do
    Gettext.put_locale(locale)

    conn
    |> put_session(:locale, locale)
    |> assign(:locale, locale)
  end
end
