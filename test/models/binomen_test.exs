defmodule BinomenTest do
  use Vivum.ModelCase, async: true
  alias Vivum.Binomen

  test "changeset with valid attributes" do
    valid_params = %{genus_name: "nymphicus", species_name: "hollandicus"}
    changeset =
      %Binomen{}
      |> Binomen.changeset(valid_params)

    assert changeset.valid?
  end

  test "changeset with missing genus" do
    changeset =
      %Binomen{}
      |> Binomen.changeset(%{species_name: "hollandicus"})

    refute changeset.valid?
    assert {:genus_name, {"can't be blank", [validation: :required]}} in changeset.errors
  end

  test "changeset with missing species" do
    changeset =
      %Binomen{}
      |> Binomen.changeset(%{genus_name: "nymphicus"})

    refute changeset.valid?
    assert {:species_name, {"can't be blank", [validation: :required]}} in changeset.errors
  end

  test "name" do
    assert Binomen.name(%Binomen{genus_name: "nymphicus", species_name: "hollandicus"}) == "Nymphicus hollandicus"
  end
end
