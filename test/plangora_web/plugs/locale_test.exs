defmodule PlangoraWeb.LocaleTest do
  use PlangoraWeb.ConnCase, asyn: true

  test "default locale will be using English", %{conn: conn} do
    conn =
      conn
      |> bypass_through(PlangoraWeb.Router, :browser)
      |> get("/")

    assert get_session(conn, :locale) == "en"
    assert %{assigns: %{locale: "en"}} = conn
  end

  test "will accept locale if input from URL params", %{conn: conn} do
    conn =
      conn
      |> bypass_through(PlangoraWeb.Router, :browser)
      |> get("/?locale=zh")

    assert get_session(conn, :locale) == "zh"
    assert %{assigns: %{locale: "zh"}} = conn
  end

  test "will not accept unkwon locale", %{conn: conn} do
    conn =
      conn
      |> bypass_through(PlangoraWeb.Router, :browser)
      |> get("/?locale=unknown")

    assert get_session(conn, :locale) == "en"
    assert %{assigns: %{locale: "en"}} = conn
  end
end
