defmodule PlangoraWeb.UserAuth do
  import Plug.Conn
  import Phoenix.Controller
  import Bcrypt, only: [verify_pass: 2, no_user_verify: 0]
  import PlangoraWeb.Gettext
  alias PlangoraWeb.Router.Helpers, as: Routes
  alias Plangora.Accounts
  @key :user_id

  def init(opts), do: opts

  def call(conn, _opts) do
    if user_id = get_session(conn, @key) do
      user = Accounts.get_user!(user_id)

      conn
      |> assign(:current_user, user)
    else
      conn
      |> redirect(to: Routes.user_session_path(conn, :new))
      |> put_flash(:error, gettext("Please login"))
      |> halt()
    end
  end

  def login(conn, %Accounts.User{} = user) do
    conn
    |> assign(:current_user, user)
    |> put_session(@key, user.id)
    |> configure_session(renew: true)
  end

  def sign_in_user(email, given_pass) do
    with user <- Accounts.find_user(email),
         true <- check_password(user, given_pass) do
      {:ok, user}
    else
      _ -> {:error, :unauthorized}
    end
  end

  def logout(conn), do: configure_session(conn, drop: true)

  defp check_password(nil, _password), do: no_user_verify()
  defp check_password(user, password), do: verify_pass(password, user.password_hash)
end
