defmodule DashwalletWeb.UploadController do
  use DashwalletWeb, :controller

  alias Dashwallet.Parser
  alias Dashwallet.Cache

  def upload(conn, %{"file" => %Plug.Upload{content_type: "text/csv"} = upload}) do
    data = parse_upload(upload.path)

    case add_to_cache(data) do
      {:ok, id} ->
        conn
        |> put_session(:tw_data_key, id)
        |> assign(:tw_data, data)
        |> put_flash(:info, "You uploaded the following file: #{upload.filename}")
        |> render("index.html")
      {:error, err} ->
        conn
        |> put_flash(:error, "There was an error processing your request. Please try again.")
        |> render("index.html")
    end
  end

  def upload(conn, _params) do
    conn
    |> put_flash(:error, "Sorry, you provided an unsupported file type.")
    |> render("index.html")
  end

  # private stuff

  defp add_to_cache(data) do
    case Cache.set(id = Cache.id(), data) do
      {:ok, true} -> {:ok, id}
      {:error, err} -> {:error, err}
    end
  end

  defp parse_upload(path) do
    path
    |> File.stream!
    |> Parser.CSV.parse_stream
    |> Stream.map(&Dashwallet.Parser.map_csv(&1))
    |> Enum.to_list
  end
end
