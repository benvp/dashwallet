defmodule DashwalletWeb.PageController do
  use DashwalletWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
