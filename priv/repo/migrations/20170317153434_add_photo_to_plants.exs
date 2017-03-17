defmodule Vivum.Repo.Migrations.AddPhotoToPlants do
  use Ecto.Migration

  def change do
    alter table(:plants) do
      add :uuid,  :string
      add :photo, :string
    end

    create unique_index(:plants, :uuid)
  end
end
