defmodule Vivum.Repo.Migrations.AddBinomenIdToPlants do
  use Ecto.Migration

  def change do
    alter table(:plants) do
      add :binomen_id, references(:binomina, on_delete: :nilify_all)
    end

    create index(:plants, :binomen_id)
  end
end
