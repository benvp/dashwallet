defmodule DashwalletWeb.DashboardController do
  use DashwalletWeb, :controller

  require Logger

  alias Dashwallet.Parser
  alias Dashwallet.Cache

  def index(conn, _params) do
    data = get_session(conn, :tw_data_key) |> Cache.get!

    if is_nil(data) do
      conn = put_flash(conn, :info, "No data present. Please upload trailwallet data first.")
    end

    conn
    |> assign(:tw_data, data)
    |> render("index.html")
  end
end
