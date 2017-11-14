defmodule DashwalletWeb.PageController do
  use DashwalletWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def parse(conn, %{"file" => %Plug.Upload{content_type: "text/csv"} = upload}) do
    IO.inspect upload

    conn
    |> put_flash(:info, "You uploaded the following file: #{upload.filename}")
    |> render("index.html")
  end

  def parse(conn, _params) do
    conn
    |> put_flash(:error, "Sorry, you provided an unsupported file type.")
    |> render("index.html")
  end
end
