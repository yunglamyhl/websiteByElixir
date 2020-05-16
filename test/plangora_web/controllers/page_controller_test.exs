defmodule PlangoraWeb.PageControllerTest do
  use PlangoraWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    refute html_response(conn, 200) =~ "Welcome"
  end
end
