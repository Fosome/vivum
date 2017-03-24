defmodule Vivum.SearchTest do
  use Vivum.ModelCase

  alias Vivum.Search
  alias Vivum.User
  alias Vivum.Binomen
  alias Vivum.Plant

  describe "Search.search/1" do
    test "search with no parameters" do
      user =
        %User{username: "mcribs", email: "m@host.com"}
        |> User.changeset()
        |> Repo.insert!()

      build_assoc(user, :plants)
        |> Plant.changeset(%{name: "Cape aloe"})
        |> Repo.insert!()

      {:ok, search} = Search.search(%{"query" => ""})
      assert search.results == []
    end

    test "search with no results" do
      search_params = %{"query" => "aloe"}
      {:ok, search} = Search.search(search_params)
      assert search.results == []
    end

    test "search sets the query string" do
      search_params = %{"query" => "aloe"}
      {:ok, search} = Search.search(search_params)
      assert search.query == "aloe"
    end

    test "search by query string" do
      user =
        %User{username: "mcribs", email: "m@host.com"}
        |> User.changeset()
        |> Repo.insert!()

      plant =
        build_assoc(user, :plants)
        |> Plant.changeset(%{name: "Cape aloe"})
        |> Repo.insert!()

      build_assoc(user, :plants)
        |> Plant.changeset(%{name: "Jade Tree"})
        |> Repo.insert!()

      search_params = %{"query" => "aloe"}
      {:ok, search} = Search.search(search_params)
      assert length(search.results) == 1

      first_result = List.first(search.results)
      assert first_result.name == plant.name
    end

    test "search by binomen id" do
      user =
        %User{username: "mcribs", email: "m@host.com"}
        |> User.changeset()
        |> Repo.insert!()

      binomen =
        %Binomen{genus_name: "aloe", species_name: "ferox"}
        |> Binomen.changeset()
        |> Repo.insert!()

      plant =
        build_assoc(user, :plants)
        |> Plant.changeset(%{name: "Cape aloe", binomen_id: binomen.id})
        |> Repo.insert!()

      build_assoc(user, :plants)
        |> Plant.changeset(%{name: "Jade Tree"})
        |> Repo.insert!()

      search_params = %{"binomen_id" => Integer.to_string(binomen.id)}
      {:ok, search} = Search.search(search_params)
      assert length(search.results) == 1

      first_result = List.first(search.results)
      assert first_result.name == plant.name
    end
  end

  describe "Search.cast/2" do
    test "cast with empty params" do
      search = Search.cast(%Search{}, %{})

      assert search.query      == nil
      assert search.binomen_id == nil
    end

    test "cast with empty values" do
      search = Search.cast(%Search{}, %{"query" => " ", "binomen_id" => ""})

      assert search.query      == nil
      assert search.binomen_id == nil
    end

    test "cast with query" do
      search = Search.cast(%Search{}, %{"query" => "aloe"})

      assert search.query == "aloe"
    end

    test "cast with binomen_id" do
      search = Search.cast(%Search{}, %{"binomen_id" => "21"})

      assert search.binomen_id == "21"
    end
  end
end
