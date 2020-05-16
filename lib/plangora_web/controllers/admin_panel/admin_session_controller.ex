defmodule PlangoraWeb.AdminSessionController do
  use PlangoraWeb, :controller

  alias PlangoraWeb.AdminAuth

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"admin_session" => %{"username" => username, "password" => password}}) do
    case AdminAuth.sign_in_admin(username, password) do
      {:ok, %Plangora.Accounts.Admin{} = admin} ->
        conn
        |> AdminAuth.login(admin)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: Routes.admin_video_post_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid login")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> AdminAuth.logout()
    |> redirect(to: Routes.video_post_path(conn, :index))
  end
end
