defmodule Vivum.Plant do
  use Vivum.Web, :model
  use Arc.Ecto.Schema

  schema "plants" do
    field :name,        :string
    field :description, :string
    field :uuid,        :string
    field :photo,       Vivum.PlantPhoto.Type

    belongs_to :user,    Vivum.User
    belongs_to :binomen, Vivum.Binomen

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :description, :binomen_id])
    |> generate_uuid()
    |> cast_attachments(params, [:photo])
    |> validate_required([:user_id, :name])
  end

  def alphabetical(query) do
    from r in query, order_by: r.name
  end


  defp generate_uuid(changeset) do
    if get_field(changeset, :uuid) == nil do
      put_change(changeset, :uuid, UUID.uuid4())
    else
      changeset
    end
  end
end
