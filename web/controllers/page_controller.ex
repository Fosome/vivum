defmodule Vivum.PageController do
  use Vivum.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
