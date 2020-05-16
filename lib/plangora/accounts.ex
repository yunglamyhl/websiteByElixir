defmodule Plangora.Accounts do
  import Ecto.Query, warn: false

  alias Plangora.Repo
  alias Plangora.Accounts.User
  alias Plangora.Accounts.Admin

  def list_users do
    Repo.all(User)
  end

  def list_admins do
    Repo.all(Admin)
  end

  def get_user!(id), do: Repo.get!(User, id)
  def get_admin!(id), do: Repo.get!(Admin, id)

  def find_user(email) do
    from(u in User, where: u.email == ^email)
    |> Repo.one()
  end

  def find_admin(username) do
    from(a in Admin, where: a.username == ^username)
    |> Repo.one()
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.register_changeset(attrs)
    |> Repo.insert()
  end

  def create_admin(attrs \\ %{}) do
    %Admin{}
    |> Admin.register_changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  def update_admin(%Admin{} = admin, attrs) do
    admin
    |> Admin.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    user
    |> User.delete_changeset(%{"is_active" => false})
    |> Repo.update()
  end

  def delete_admin(%Admin{} = admin) do
    admin
    |> Admin.delete_changeset(%{"is_active" => false})
    |> Repo.update()
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def change_admin(%Admin{} = admin) do
    Admin.changeset(admin, %{})
  end
end
