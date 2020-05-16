defmodule PlangoraWeb.UserControllerTest do
  use PlangoraWeb.ConnCase, async: true
  alias Plangora.Accounts

  test "can see sign up page", %{conn: conn} do
    conn = get(conn, Routes.user_path(conn, :new))
    assert html_response(conn, 200)
  end

  test "can sign up", %{conn: conn} do
    email = "user@test.com"

    conn =
      post(conn, Routes.user_path(conn, :create), %{
        user: %{
          name: "Test Name",
          email: email,
          password: "test1234",
          password_confirmation: "test1234"
        }
      })

    assert redirected_to(conn, 302) =~ Routes.video_post_path(conn, :index)
    assert get_flash(conn, :info) == "Sign up successful!"
    refute get_session(conn, :user_id) == nil
  end

  test "cannot sign up if bad params", %{conn: conn} do
    conn = post(conn, Routes.user_path(conn, :create), %{user: %{name: "bad"}})
    assert html_response(conn, 200)

    assert get_flash(conn, :error) ==
             "There was an error while signing up, please fix and try again"

    assert nil == Accounts.find_user("bad")
  end
end
