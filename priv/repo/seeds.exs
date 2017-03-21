# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Vivum.Repo.insert!(%Vivum.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Vivum.Repo

### Users

user_data = [
  %{
    username:              "alice",
    email:                 "alice@host.com",
    password:              "password",
    password_confirmation: "password"
  },
  %{
    username:              "bob",
    email:                 "bob@host.com",
    password:              "password",
    password_confirmation: "password"
  },
  %{
    username:              "chuck",
    email:                 "chuck@host.com",
    password:              "password",
    password_confirmation: "password"
  },
  %{
    username:              "dale",
    email:                 "dale@host.com",
    password:              "password",
    password_confirmation: "password"
  },
  %{
    username:              "erin",
    email:                 "erin@host.com",
    password:              "password",
    password_confirmation: "password"
  },
]

Enum.each user_data, fn %{username: username} = params ->
  Repo.get_by(Vivum.User, username: username) ||
    %Vivum.User{}
    |> Vivum.User.registration_changeset(params)
    |> Repo.insert!()
end

alice = Repo.get_by(Vivum.User, username: "alice")


### Binomina (scientific names)

binomina = [
  %{
    genus_name:   "euphorbia",
    species_name: "trigona"
  },
  %{
    genus_name:   "sedum",
    species_name: "morganianum"
  },
  %{
    genus_name:   "aloe",
    species_name: "ferox"
  },
  %{
    genus_name:   "adenium",
    species_name: "obesum"
  },
  %{
    genus_name:   "euphorbia",
    species_name: "lactea"
  },
  %{
    genus_name:   "sedum",
    species_name: "sarmentosum"
  },
  %{
    genus_name:   "sempervivum",
    species_name: "tectorum"
  },
  %{
    genus_name:   "crassula",
    species_name: "ovata"
  },
  %{
    genus_name:   "sansevieria",
    species_name: "trifasciata"
  },
  %{
    genus_name:   "euphorbia",
    species_name: "tirucalli"
  }
]

Enum.each binomina, fn %{genus_name: genus, species_name: species} = params ->
  Repo.get_by(Vivum.Binomen, genus_name: genus, species_name: species) ||
    %Vivum.Binomen{}
    |> Vivum.Binomen.changeset(params)
    |> Repo.insert!()
end


### Plants

plant_names = [
  "African Milk Tree",
  "Burro's Tail",
  "Cape Aloe",
  "Desert Rose",
  "Elkhorn",
  "Gold moss",
  "Hens and chicks",
  "Jade Tree",
  "Kiwi Aeonium",
  "Lace Aloe",
  "Mothers Tongue",
  "Naked Lady",
  "Old Hens",
  "Pencil Cactus",
  "Ruby glow",
  "Saguaro Cactus",
  "Toad Cactus",
  "Wax agave"
]

Enum.each plant_names, fn name ->
  Repo.get_by(Vivum.Plant, name: name, user_id: alice.id) ||
    Repo.insert!(%Vivum.Plant{name: name, user_id: alice.id})
end
