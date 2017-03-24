defmodule Vivum.SearchView do
  use Vivum.Web, :view
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
end
