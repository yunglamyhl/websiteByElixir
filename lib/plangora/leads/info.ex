defmodule Plangora.Leads.Info do
  use Ecto.Schema
  import Ecto.Changeset

  schema "leads" do
    field :name, :string
    field :phone, :string
    field :email, :string
    field :message, :string

    timestamps()
  end

  @allowed_attrs [
    :name,
    :phone,
    :email,
    :message
  ]

  @required_attrs [
    :name,
    :email,
    :message
  ]

  @phone_regex ~r/^[0-9]+$/
  @email_regex ~r/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  def changeset(lead, attrs) do
    lead
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs)
    |> validate_length(:phone, min: 8, max: 8)
    |> validate_format(:phone, @phone_regex)
    |> validate_format(:email, @email_regex)
    |> validate_length(:name, max: 255)
  end
end
