defmodule DashwalletWeb.DashboardController do
  use DashwalletWeb, :controller

  require Logger

  alias Dashwallet.Parser
  alias Dashwallet.Cache

  def index(conn, _params) do
    data = get_session(conn, :tw_data_key) |> Cache.get!

    case is_nil(data) do
      true ->
        conn
        |> put_flash(:info, "No data present. Please upload trailwallet data first.")
        |> redirect(to: upload_path(conn, :index))
      _ ->
        expenses_by_tag = Parser.expenses_by_tag(data) |> Poison.encode!

        conn
        |> assign(:expenses_by_tag, expenses_by_tag)
        |> render("index.html")
    end
  end
end
