defmodule Vivum.User do
  use Vivum.Web, :model

  schema "users" do
    field :username,      :string
    field :email,         :string
    field :password,      :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:username, :email])
    |> validate_required([:username, :email])
    |> validate_length(:username, min: 3)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_confirmation(:password, required: true)
  end
end
