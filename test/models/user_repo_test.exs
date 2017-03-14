defmodule Vivum.UserRepoTest do
  use Vivum.ModelCase
  alias Vivum.User

  test "changeset with duplicate username" do
    %User{}
    |> User.changeset(%{username: "mcribs", email: "m@host.com"})
    |> Repo.insert!()

    assert {:error, changeset} = Repo.insert(User.changeset(%User{}, %{username: "mcribs", email: "other@host.com"}))
    assert {:username, {"has already been taken", []}} in changeset.errors
  end

  test "changeset with duplicate email" do
    %User{}
    |> User.changeset(%{username: "mcribs", email: "m@host.com"})
    |> Repo.insert!()

    assert {:error, changeset} = Repo.insert(User.changeset(%User{}, %{username: "other", email: "m@host.com"}))
    assert {:email, {"has already been taken", []}} in changeset.errors
  end
end
