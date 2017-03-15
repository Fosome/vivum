defmodule Vivum.SessionController do
  use Vivum.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    case Vivum.Auth.login_by_username_and_password(conn, username, password) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: page_path(conn, :index))
      {:error, conn} ->
        conn
        |> put_flash(:error, "Invalid username and password")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Vivum.Auth.logout()
    |> put_flash(:info, "Signed out")
    |> redirect(to: page_path(conn, :index))
  end
end
