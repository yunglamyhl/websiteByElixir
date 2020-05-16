defmodule Plangora.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :is_active, :boolean, default: true

    timestamps()
  end

  @required_attributes [
    :email,
    :name,
    :is_active,
    :password,
    :password_confirmation
  ]

  @allowed_attributes [
    :name,
    :is_active,
    :password,
    :password_confirmation
  ]

  def changeset(user, attrs) do
    user
    |> cast(attrs, @allowed_attributes)
    |> email_changeset(attrs)
    |> validate_length(:password, min: 8, message: "must be at least %{count} characters")
    |> validate_confirmation(:password, message: "does not match password")
    |> put_pass_hash()
  end

  def email_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_format(:email, ~r/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
      message: "must be an email"
    )
    |> validate_required([:email])
    |> unique_constraint(:email)
  end

  def register_changeset(user, attrs) do
    changeset(user, attrs)
    |> validate_required(@required_attributes)
  end

  def update_changeset(user, attrs) do
    changeset(user, attrs)
    |> validate_required([:password])
  end

  def delete_changeset(user, attrs) do
    user
    |> cast(attrs, [:is_active])
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} when is_binary(pass) ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end
