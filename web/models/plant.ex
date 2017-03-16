defmodule Vivum.Plant do
  use Vivum.Web, :model

  schema "plants" do
    field :name,        :string
    field :description, :string

    belongs_to :user, Vivum.User

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :description])
    |> validate_required([:name])
  end
end
