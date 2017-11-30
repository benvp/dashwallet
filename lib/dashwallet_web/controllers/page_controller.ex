defmodule DashwalletWeb.PageController do
  use DashwalletWeb, :controller

  require Logger

  def index(conn, _params) do
    render conn, "index.html"
  end

  def parse(conn, %{"file" => %Plug.Upload{content_type: "text/csv"} = upload}) do
    IO.inspect upload

    data = upload.path
    |> File.stream!
    |> Dashwallet.Parser.CSV.parse_stream
    |> Stream.map(&Dashwallet.Parser.map_csv(&1))
    |> Enum.to_list

    conn
    |> assign(:trailwallet_data, data)
    |> put_flash(:info, "You uploaded the following file: #{upload.filename}")
    |> render("index.html")
  end

  def parse(conn, _params) do
    conn
    |> put_flash(:error, "Sorry, you provided an unsupported file type.")
    |> render("index.html")
  end
end
