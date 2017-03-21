defmodule Vivum.SearchTest do
  use Vivum.ModelCase

  alias Vivum.Search
  alias Vivum.User
  alias Vivum.Plant

  test "search by string query" do
    assert {:ok, _search} = Search.search("aloe")
  end

  test "search by non-string query" do
    assert {:error, _search} = Search.search(43)
  end

  test "search sets the query string" do
    {:ok, search} = Search.search("aloe")
    assert search.query == "aloe"
  end

  test "search with no results" do
    {:ok, search} = Search.search("aloe")
    assert search.results == []
  end

  test "search with results" do
    user =
      %User{username: "mcribs", email: "m@host.com"}
      |> User.changeset()
      |> Repo.insert!()

    plant =
      build_assoc(user, :plants)
      |> Plant.changeset(%{name: "Cape aloe"})
      |> Repo.insert!()

    {:ok, search} = Search.search("aloe")
    assert length(search.results) == 1

    first_result = List.first(search.results)
    assert first_result.name == plant.name
  end
end
