defmodule Vivum.PlantView do
  use Vivum.Web, :view
  import Scrivener.HTML

  alias Vivum.Binomen

  def binomen_name(binomen) do
    Binomen.name(binomen)
  end

  def binomen_options(binomina) do
    Enum.map(binomina, fn (%Binomen{id: id} = binomen) ->
      {
        binomen_name(binomen),
        id
      }
    end)
  end

  def owner?(conn, plant) do
    plant.user == conn.assigns[:current_user]
  end
end
