defmodule Vivum.Repo.Migrations.CreateBinomina do
  use Ecto.Migration

  def change do
    create table(:binomina) do
      add :genus_name,   :string, null: false
      add :species_name, :string, null: false

      timestamps()
    end
  end
end
