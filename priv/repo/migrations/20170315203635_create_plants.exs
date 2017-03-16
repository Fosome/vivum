defmodule Vivum.Repo.Migrations.CreatePlants do
  use Ecto.Migration

  def change do
    create table(:plants) do
      add :name,        :string, null: false
      add :description, :text

      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:plants, :user_id)
  end
end
