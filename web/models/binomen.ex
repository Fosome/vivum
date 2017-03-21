defmodule Vivum.Binomen do
  use Vivum.Web, :model

  schema "binomina" do
    field :genus_name,   :string
    field :species_name, :string

    has_many :plants, Vivum.Plant

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:genus_name, :species_name])
    |> validate_required([:genus_name, :species_name])
  end

  def alphabetical(query) do
    from r in query, order_by: [r.genus_name, r.species_name]
  end

  def name(binomen) do
    [binomen.genus_name, " ", binomen.species_name]
    |> List.to_string()
    |> String.capitalize()
  end
end
