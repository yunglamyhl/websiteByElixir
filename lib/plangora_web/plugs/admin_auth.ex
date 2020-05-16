defmodule PlangoraWeb.AdminAuth do
  import Plug.Conn
  import Phoenix.Controller
  import Bcrypt, only: [verify_pass: 2, no_user_verify: 0]
  alias PlangoraWeb.Router.Helpers, as: Routes
  alias Plangora.Accounts
  @key :admin_id

  def init(opts), do: opts

  def call(conn, _opts) do
    if admin_id = Plug.Conn.get_session(conn, @key) do
      admin = Accounts.get_admin!(admin_id)

      conn
      |> assign(:current_admin, admin)
    else
      conn
      |> redirect(to: Routes.admin_session_path(conn, :new))
      |> put_flash(:error, "Please login")
      |> halt()
    end
  end

  def login(conn, %Accounts.Admin{} = admin) do
    conn
    |> assign(:current_admin, admin)
    |> put_session(@key, admin.id)
    |> configure_session(renew: true)
  end

  def sign_in_admin(username, given_pass) do
    with admin <- Accounts.find_admin(username),
         true <- check_password(admin, given_pass) do
      {:ok, admin}
    else
      _ -> {:error, :unauthorized}
    end
  end

  def logout(conn), do: configure_session(conn, drop: true)

  defp check_password(nil, _password), do: no_user_verify()
  defp check_password(admin, password), do: verify_pass(password, admin.password_hash)
end
