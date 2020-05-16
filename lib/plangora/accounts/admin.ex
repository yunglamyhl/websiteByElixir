defmodule Plangora.Accounts.Admin do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plangora.Multimedia.VideoPost

  schema "admins" do
    field :username, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :is_active, :boolean, default: true

    has_many(:video_posts, VideoPost)

    timestamps()
  end

  @required_attributes [
    :username,
    :is_active,
    :password,
    :password_confirmation
  ]

  @allowed_attributes [
    :username,
    :is_active,
    :password,
    :password_confirmation
  ]

  def changeset(admin, attrs) do
    admin
    |> cast(attrs, @allowed_attributes)
    |> unique_constraint(:username)
    |> validate_length(:password, min: 8, message: "must be at least %{count} characters")
    |> validate_confirmation(:password, message: "does not match password")
    |> put_pass_hash()
  end

  def register_changeset(admin, attrs) do
    changeset(admin, attrs)
    |> validate_required(@required_attributes)
  end

  def update_changeset(admin, attrs) do
    changeset(admin, attrs)
    |> validate_required([:password])
  end

  def delete_changeset(admin, attrs) do
    admin
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
