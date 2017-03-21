defmodule Vivum.Search do
  import Ecto.Query

  defstruct query: nil, results: []

  alias Vivum.Search
  alias Vivum.Repo
  alias Vivum.Plant

  def search(query) when is_binary(query) do
    search =
      %Search{query: query}
      |> run_query()

    {:ok, search}
  end

  def search(_), do: {:error, %Search{}}


  defp run_query(search) do
    results =
      build_query(search)
      |> Repo.all()

    Map.put(search, :results, results)
  end

  defp build_query(%Search{query: query}) do
    fquery = "%#{query}%"

    from p in Plant,
      where: ilike(p.name, ^fquery),
      preload: [:user, :binomen]
  end
end
