defmodule Vivum.Search do
  import Ecto.Query

  defstruct query:      nil,
            binomen_id: nil,
            results:    []

  alias Vivum.Search
  alias Vivum.Repo
  alias Vivum.Plant

  def search(%Search{} = search) do
    search = run_search(search)
    {:ok, search}
  end

  def search(%{} = params) do
    search = cast(%Search{}, params)
    search(search)
  end

  def cast(model, params) do
    query      = cast_param(params["query"])
    binomen_id = cast_param(params["binomen_id"])

    model
      |> Map.put(:query, query)
      |> Map.put(:binomen_id, binomen_id)
  end


  defp run_search(%Search{query: nil, binomen_id: nil} = search) do
    search
  end

  defp run_search(search) do
    results =
      build_query(search)
      |> Repo.all()

    Map.put(search, :results, results)
  end

  defp build_query(search) do
    Plant
      |> base_query()
      |> text_query(search)
      |> binomen_query(search)
  end

  defp base_query(query) do
    from p in query,
      preload: [:user, :binomen]
  end

  defp text_query(query, %Search{query: nil}), do: query

  defp text_query(query, %Search{query: text}) do
    ftext = "%#{text}%"

    from p in query,
      where: ilike(p.name,        ^ftext) or
             ilike(p.description, ^ftext)
  end

  defp binomen_query(query, %Search{binomen_id: nil}), do: query

  defp binomen_query(query, %Search{binomen_id: id}) do
    from p in query,
      where: p.binomen_id == ^id
  end

  defp cast_param(nil), do: nil

  defp cast_param(val) when is_binary(val) do
    val = String.trim(val)
    case val do
      "" -> nil
      _  -> val
    end
  end
end
