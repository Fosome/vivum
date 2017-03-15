defmodule Vivum.Auth do
  import Plug.Conn
  import Phoenix.Controller
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias Vivum.Router.Helpers
  alias Vivum.Repo
  alias Vivum.User

  def init(_opts) do
  end

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    cond do
      user = conn.assigns[:current_user] ->
        conn
      user = user_id && Repo.get(User, user_id) ->
        assign(conn, :current_user, user)
      true ->
        assign(conn, :current_user, nil)
    end
  end

  def authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt()
    end
  end

  def login_by_username_and_password(conn, username, password) do
    user = Repo.get_by(User, username: username)

    cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, login(conn, user)}
      true ->
        dummy_checkpw()
        {:error, conn}
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    delete_session(conn, :user_id)
  end
end
