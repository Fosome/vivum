defmodule Vivum.SearchController do
  use Vivum.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end

  def show(conn, %{"search" => %{"query" => query}}) do
    {:ok, search} = Vivum.Search.search(query)

    render conn, "show.html", search: search
  end
end
