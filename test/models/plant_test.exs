defmodule PlantTest do
  use Vivum.ModelCase, async: true
  alias Vivum.Plant
  alias Vivum.User

  test "changeset with valid attributes" do
    plant_params = %{name: "panda", description: "kalanchoe"}
    changeset = 
      %User{id: 1}
      |> build_assoc(:plants)
      |> Plant.changeset(plant_params)

    assert changeset.valid?
  end

  test "changeset with missing name" do
    plant_params = %{description: "kalanchoe"}
    changeset = 
      %User{id: 1}
      |> build_assoc(:plants)
      |> Plant.changeset(plant_params)

    refute changeset.valid?
    assert {:name, {"can't be blank", [validation: :required]}} in changeset.errors
  end

  test "changeset with missing user" do
    plant_params = %{name: "panda", description: "kalanchoe"}
    changeset = 
      %User{}
      |> build_assoc(:plants)
      |> Plant.changeset(plant_params)

    refute changeset.valid?
    assert {:user_id, {"can't be blank", [validation: :required]}} in changeset.errors
  end

  test "changeset sets a uuid if missing" do
    changeset = 
      %User{id: 1}
      |> build_assoc(:plants)
      |> Plant.changeset()

    assert get_field(changeset, :uuid)
  end

  test "changeset ignores uuid if present" do
    changeset = 
      %User{id: 1}
      |> build_assoc(:plants, %{uuid: "123"})
      |> Plant.changeset()

    assert get_field(changeset, :uuid) == "123"
  end
end
