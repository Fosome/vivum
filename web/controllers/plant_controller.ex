defmodule Vivum.PlantController do
  use Vivum.Web, :controller
  alias Vivum.Plant
  alias Vivum.Binomen

  plug :authenticate  when action in [:index, :new, :create, :edit, :update, :delete]
  plug :load_binomina when action in [:new, :create, :edit, :update]

  def index(conn, params, current_user) do
    plant_query =
      current_user
      |> Ecto.assoc(:plants)
      |> Plant.alphabetical()

    paginator = Repo.paginate(plant_query, params)

    render conn, "index.html", paginator: paginator
  end

  def show(conn, %{"id" => id}, _current_user) do
    plant =
      Repo.get(Plant,  id)
      |> Repo.preload(:user)
      |> Repo.preload(:binomen)

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

  def edit(conn, %{"id" => id}, current_user) do
    plant_query = Ecto.assoc(current_user, :plants)
    plant       = Repo.get(plant_query, id)
    changeset   = Plant.changeset(plant)

    render conn, "edit.html", changeset: changeset, plant: plant
  end

  def update(conn, %{"id" => id, "plant" => plant_params}, current_user) do
    plant_query = Ecto.assoc(current_user, :plants)
    plant       = Repo.get(plant_query, id)
    changeset   = Plant.changeset(plant, plant_params)

    case Repo.update(changeset) do
      {:ok, plant} ->
        conn
        |> put_flash(:info, "Success")
        |> redirect(to: plant_path(conn, :show, plant))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "There were errors")
        |> render("edit.html", plant: plant, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    plant_query = Ecto.assoc(current_user, :plants)
    plant       = Repo.get(plant_query, id)

    Repo.delete!(plant)

    conn
    |> put_flash(:info, "Success")
    |> redirect(to: plant_path(conn, :index))
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


  defp load_binomina(conn, _) do
    query    = Binomen.alphabetical(Binomen)
    binomina = Repo.all(query)
    assign(conn, :binomina, binomina)
  end
end
