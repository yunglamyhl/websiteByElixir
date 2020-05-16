defmodule PlangoraWeb.AdminSessionControllerTest do
  use PlangoraWeb.ConnCase, async: true

  alias Plangora.Accounts

  test "can see login page for admin", %{conn: conn} do
    conn = get(conn, Routes.admin_session_path(conn, :new))
    assert html_response(conn, 200) =~ "Admin Login"
  end

  setup do: {:ok, %{admin: admin_fixture()}}

  @create_admin_attrs %{
    username: "admin",
    password: "admintest",
    password_confirmation: "admintest"
  }

  def admin_fixture(attrs \\ %{}) do
    {:ok, admin} =
      attrs
      |> Enum.into(@create_admin_attrs)
      |> Accounts.create_admin()

    admin
    |> Map.put(:password, nil)
  end

  test "login with valid name and password", %{conn: conn} do
    conn =
      post(conn, Routes.admin_session_path(conn, :create), %{
        admin_session: %{username: "admin", password: "admintest"}
      })

    assert get_flash(conn, :info) == "Welcome back!"
    assert redirected_to(conn, 302) =~ Routes.admin_video_post_path(conn, :index)
  end

  test "cannot login with invalid name or password", %{conn: conn, admin: %{username: name}} do
    conn =
      post(conn, Routes.admin_session_path(conn, :create), %{
        admin_session: %{username: name, password: "wrongpassword"}
      })

    assert get_flash(conn, :error) == "Invalid login"
  end

  test "can log out", %{conn: conn, admin: admin} do
    conn =
      conn
      |> bypass_through(PlangoraWeb.Router, :browser)
      |> get("/")
      |> PlangoraWeb.AdminAuth.login(admin)
      |> send_resp(:ok, "")

    conn = delete(conn, Routes.admin_session_path(conn, :delete))
    assert redirected_to(conn, 302) =~ Routes.video_post_path(conn, :index)
  end
end
