defmodule PlangoraWeb.UserSessionControllerTest do
  use PlangoraWeb.ConnCase, async: true

  alias Plangora.Accounts

  setup do: {:ok, %{user: user_fixture()}}

  @create_user_attrs %{
    name: "user",
    email: "user@test.com",
    password: "usertest",
    password_confirmation: "usertest"
  }

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@create_user_attrs)
      |> Accounts.create_user()

    user
    |> Map.put(:password, nil)
  end

  test "can see login page", %{conn: conn} do
    conn = get(conn, Routes.user_session_path(conn, :new))
    assert html_response(conn, 200) =~ "Login"
  end

  test "login with valid email and password", %{conn: conn, user: %{email: email}} do
    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        session: %{email: email, password: "usertest"}
      })

    assert get_flash(conn, :info) == "Welcome back!"
    assert redirected_to(conn, 302) =~ Routes.video_post_path(conn, :index)
  end

  test "cannot login with invalid email or password", %{conn: conn} do
    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        session: %{email: "wrongemail", password: "wrongpassword"}
      })

    assert get_flash(conn, :error) == "Invalid login"
  end

  test "can log out", %{conn: conn, user: user} do
    conn =
      conn
      |> bypass_through(PlangoraWeb.Router, :browser)
      |> get("/")
      |> PlangoraWeb.UserAuth.login(user)
      |> send_resp(:ok, "")

    conn = delete(conn, Routes.user_session_path(conn, :delete))
    assert redirected_to(conn, 302) =~ Routes.video_post_path(conn, :index)
  end
end
