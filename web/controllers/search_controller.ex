defmodule Vivum.SearchController do
  use Vivum.Web, :controller
  alias Vivum.Search
  alias Vivum.Binomen

  plug :load_binomina

  def new(conn, _params) do
    render conn, "new.html"
  end

  def show(conn, %{"search" => search_params}) do
    {:ok, search} = Search.search(search_params)

    render conn, "show.html", search: search
  end


  defp load_binomina(conn, _) do
    query    = Binomen.alphabetical(Binomen)
    binomina = Repo.all(query)
    assign(conn, :binomina, binomina)
  end
end
