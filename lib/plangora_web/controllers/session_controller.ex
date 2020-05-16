defmodule PlangoraWeb.UserSessionController do
  use PlangoraWeb, :controller
  alias PlangoraWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case UserAuth.sign_in_user(email, password) do
      {:ok, %Plangora.Accounts.User{} = user} ->
        conn
        |> UserAuth.login(user)
        |> put_flash(:info, gettext("Welcome back!"))
        |> redirect(to: Routes.video_post_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, gettext("Invalid login"))
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> UserAuth.logout()
    |> redirect(to: Routes.video_post_path(conn, :index))
  end
end
