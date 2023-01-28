defmodule WhoIsBetterWeb.PageController do
  use WhoIsBetterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
