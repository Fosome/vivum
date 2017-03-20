defmodule Vivum.Repo do
  use Ecto.Repo, otp_app: :vivum
  use Scrivener, page_size: 10
end
