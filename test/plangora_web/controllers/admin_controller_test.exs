defmodule PlangoraWeb.AdminControllerTest do
  use PlangoraWeb.ConnCase, async: true

  setup %{conn: conn} do
    {:ok, conn: conn}
  end

  test "cannot see sign up page for admin", %{conn: conn} do
    conn = get(conn, Routes.admin_path(conn, :new))
    assert redirected_to(conn, 302) =~ Routes.admin_session_path(conn, :new)
  end
end
