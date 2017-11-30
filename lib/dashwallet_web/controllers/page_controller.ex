defmodule DashwalletWeb.PageController do
  use DashwalletWeb, :controller

  require Logger

  alias Dashwallet.Parser

  def index(conn, _params) do
    render conn, "index.html"
  end

  def parse(conn, %{"file" => %Plug.Upload{content_type: "text/csv"} = upload}) do

    data = parse_upload(upload.path)
    |> Parser.entries_for_trip
    |> Poison.encode!

    conn
    |> assign(:trailwallet_data, data)
    |> put_flash(:info, "You uploaded the following file: #{upload.filename}")
    |> render("dashboard.html")
  end

  def parse(conn, _params) do
    conn
    |> put_flash(:error, "Sorry, you provided an unsupported file type.")
    |> render("index.html")
  end

  defp parse_upload(path) do
    path
    |> File.stream!
    |> Parser.CSV.parse_stream
    |> Stream.map(&Dashwallet.Parser.map_csv(&1))
    |> Enum.to_list
  end
end
