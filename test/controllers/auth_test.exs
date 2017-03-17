defmodule Vivum.AuthTest do
  use Vivum.ConnCase
  alias Vivum.Auth
  alias Vivum.User

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(Vivum.Router, :browser)
      |> get("/")

    {:ok, %{conn: conn}}
  end

  test "call passes thru current user if present", %{conn: conn} do
    conn =
      conn
      |> assign(:current_user, %Vivum.User{})
      |> Auth.call([])

    assert conn.assigns[:current_user]
  end

  test "call assigns the current user by id", %{conn: conn} do
    user_attrs = %{
      username:              "user",
      email:                 "email@host.com",
      password:              "secr3t",
      password_confirmation: "secr3t"
    }

    user =
      %User{}
      |> User.registration_changeset(user_attrs)
      |> Repo.insert!()

    conn =
      conn
      |> put_session(:user_id, user.id)
      |> Auth.call([])

    assert conn.assigns[:current_user]
  end

  test "call assigns nil to current user when no user id set", %{conn: conn} do
    conn = Auth.call(conn, [])

    refute conn.assigns[:current_user]
  end

  test "call assigns nil to current user when bad user id set", %{conn: conn} do
    conn =
      conn
      |> put_session(:user_id, -1)
      |> Auth.call([])

    refute conn.assigns[:current_user]
  end

  test "authenticate passes thru the conn if current user", %{conn: conn} do
    conn =
      conn
      |> assign(:current_user, %User{})
      |> Auth.authenticate([])

    refute conn.halted
  end

  test "authenticate halts the conn if no current user", %{conn: conn} do
    conn = Auth.authenticate(conn, [])

    assert conn.halted
  end

  test "login by u/p with valid username and password", %{conn: conn} do
    user_attrs = %{
      username:              "mcribs",
      email:                 "email@host.com",
      password:              "secr3t",
      password_confirmation: "secr3t"
    }

    %User{}
    |> User.registration_changeset(user_attrs)
    |> Repo.insert!()

    {status, conn} = Auth.login_by_username_and_password(conn, "mcribs", "secr3t")

    assert status == :ok
    assert conn.assigns[:current_user]
  end

  test "login by u/p with invalid username and password", %{conn: conn} do
    {status, conn} = Auth.login_by_username_and_password(conn, "mcribs", "secr3t")

    assert status == :error
    refute conn.assigns[:current_user]
  end

  test "login with user", %{conn: conn} do
    conn = Auth.login(conn, %User{id: 1})

    assert conn.assigns[:current_user]
    assert get_session(conn, :user_id)
  end

  test "logout", %{conn: conn} do
    conn =
      conn
      |> put_session(:user_id, 1)
      |> Auth.logout()

    refute get_session(conn, :user_id)
  end
end
