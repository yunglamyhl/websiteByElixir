defmodule PlangoraWeb.MaybeAuth do
  import Plug.Conn

  alias Plangora.Accounts

  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    # user_id =
    #   case get_session(conn, :user_id) do
    #     nil ->
    #       nil

    #     user_id ->
    #       Logger.metadata()
    #       Logger.debug user_id
    #       user_id

    #   end

    #   user = nil

    #   if user_id != nil do
    #     user =
    #     case Accounts.get_user!(user_id) do
    #       nil ->
    #         nil

    #       user ->
    #         Logger.debug inspect(user)
    #         user

    #     end
    #   end
    #   if user_id != nil do
    #     conn
    #     |> assign(:user_id, user_id)
    #     |> assign(:current_user, user)

    with user_id when not is_nil(user_id) <- get_session(conn, :user_id),
         user when not is_nil(user) <- Accounts.get_user!(user_id) do
      conn
      |> assign(:user_id, user_id)
      |> assign(:current_user, user)
    else
      _ ->
        conn
    end
  end
end
