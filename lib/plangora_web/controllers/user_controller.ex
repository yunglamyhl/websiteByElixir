defmodule PlangoraWeb.UserController do
  use PlangoraWeb, :controller
  alias Plangora.Accounts
  alias Plangora.Accounts.User
  alias PlangoraWeb.UserAuth

  def new(conn, _params), do: render(conn, "new.html", changeset: Accounts.change_user(%User{}))

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> UserAuth.login(user)
        |> put_flash(:info, gettext("Sign up successful!"))
        |> redirect(to: Routes.video_post_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_flash(
          :error,
          gettext("There was an error while signing up, please fix and try again")
        )
        |> render("new.html", changeset: changeset)
    end
  end
end
