defmodule Vivum.PlantController do
  use Vivum.Web, :controller
  alias Vivum.Plant

  plug :authenticate

  def index(conn, _params, current_user) do
    plant_query = Ecto.assoc(current_user, :plants)
    plants      = Repo.all(plant_query)

    render conn, "index.html", plants: plants
  end

  def show(conn, %{"id" => id}, current_user) do
    plant_query = Ecto.assoc(current_user, :plants)
    plant = Repo.get(plant_query, id)

    render conn, "show.html", plant: plant
  end

  def new(conn, _params, current_user) do
    changeset =
      current_user
      |> build_assoc(:plants)
      |> Plant.changeset()

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"plant" => plant_params}, current_user) do
    changeset = 
      current_user
      |> build_assoc(:plants)
      |> Plant.changeset(plant_params)

    case Repo.insert(changeset) do
      {:ok, _plant} ->
        conn
        |> put_flash(:info, "Success")
        |> redirect(to: plant_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "There were errors")
        |> render("new.html", changeset: changeset)
    end
  end

  def action(conn, _) do
    apply(
      __MODULE__,
      action_name(conn),
      [
        conn,
        conn.params,
        conn.assigns.current_user
      ]
    )
  end
end
