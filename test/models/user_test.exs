defmodule Vivum.UserTest do
  use Vivum.ModelCase, async: true
  alias Vivum.User

  test "changeset with valid attributes" do
    valid_attrs = %{username: "mcribs", email: "mcribs@host.com"}
    changeset = User.changeset(%User{}, valid_attrs)

    assert changeset.valid?
  end

  test "changeset with missing username" do
    changeset = User.changeset(%User{}, %{})

    refute changeset.valid?
    assert {:username, {"can't be blank", [validation: :required]}} in changeset.errors
  end

  test "changeset with username that is too short" do
    changeset = User.changeset(%User{}, %{username: "aa"})

    refute changeset.valid?
    assert {:username, {"should be at least %{count} character(s)", [count: 3, validation: :length, min: 3]}} in changeset.errors
  end

  test "changeset with missing email" do
    changeset = User.changeset(%User{}, %{})

    refute changeset.valid?
    assert {:email, {"can't be blank", [validation: :required]}} in changeset.errors
  end

  test "registration changeset with valid attributes" do
    valid_attrs = %{
      username:              "mcribs",
      email:                 "mcribs@host.com",
      password:              "secr3t",
      password_confirmation: "secr3t"
    }
    changeset = User.registration_changeset(%User{}, valid_attrs)

    assert changeset.valid?
  end

  test "registration changeset with missing password" do
    changeset = User.registration_changeset(
      %User{},
      %{
        username: "mcribs",
        email:    "mcribs@host.com"
      }
    )

    refute changeset.valid?
    assert {:password, {"can't be blank", [validation: :required]}} in changeset.errors
  end

  test "registration changeset with mismatched password confirmation" do
    changeset = User.registration_changeset(
      %User{},
      %{
        username:              "mcribs",
        email:                 "mcribs@host.com",
        password:              "secr3t",
        password_confirmation: "secr9t"
      }
    )

    refute changeset.valid?
    assert {:password_confirmation, {"does not match confirmation", [validation: :confirmation]}} in changeset.errors
  end

  test "registration changeset will hash the password" do
    changeset = User.registration_changeset(
      %User{},
      %{
        username:              "mcribs",
        email:                 "mcribs@host.com",
        password:              "secr3t",
        password_confirmation: "secr3t"
      }
    )

    assert changeset.valid?
    refute get_field(changeset, :password_hash) == nil
  end

  test "registration changeset will not hash the password for invalid changes" do
    changeset = User.registration_changeset(
      %User{},
      %{
        username:              "mcribs",
        email:                 "mcribs@host.com",
        password:              "secr3t",
        password_confirmation: "nope"
      }
    )

    refute changeset.valid?
    assert get_field(changeset, :password_hash) == nil
  end
end
