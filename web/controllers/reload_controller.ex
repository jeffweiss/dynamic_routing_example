defmodule DynamicRouting.ReloadController do
  use DynamicRouting.Web, :controller

  def reload(conn, _params) do
    reloaded = Code.load_file("web/router.ex")
    send_resp(conn, 200, "#{inspect reloaded}")
  end
end
