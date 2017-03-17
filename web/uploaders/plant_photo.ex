defmodule Vivum.PlantPhoto do
  use Arc.Definition

  # Include ecto support (requires package arc_ecto installed):
  use Arc.Ecto.Definition

  # To add a thumbnail version:
  # @versions [:original, :thumb]

  @versions [
    :original,
    :normal,
    :thumbnail
  ]

  @extension_whitelist [
    ".jpg",
    ".jpeg",
    ".gif",
    ".png"
  ]

  # Whitelist file extensions:
  def validate({file, _}) do
    extension = file.file_name |> Path.extname() |> String.downcase()
    Enum.member?(@extension_whitelist, extension)
  end

  # Define a thumbnail transformation:
  def transform(:original, _), do: :noaction

  def transform(:normal, _) do
    {
      :convert,
      "-strip -resize 480x480 -format png",
      :png
    }
  end

  def transform(:thumbnail, _) do
    {
      :convert,
      "-strip -thumbnail 200x200^ -gravity center -extent 200x200 -format png",
      :png
    }
  end

  # Override the persisted filenames:
  def filename(version, _) do
    version
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, scope}) do
    "uploads/plant/photos/#{scope.uuid}"
  end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: Plug.MIME.path(file.file_name)]
  # end
end
