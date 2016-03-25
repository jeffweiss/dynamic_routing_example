defmodule DynamicRouting.PageController do
  use DynamicRouting.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
