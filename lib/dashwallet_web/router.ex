defmodule DashwalletWeb.Router do
  use DashwalletWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    # disabled csrf protection because we require
    # a POST Request with the trail wallet data to process (e.g. CSV)
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DashwalletWeb do
    pipe_through :browser # Use the default browser stack

    get "/", DashboardController, :index
    post "/upload", UploadController, :upload
  end

  # Other scopes may use custom stacks.
  # scope "/api", DashwalletWeb do
  #   pipe_through :api
  # end
end
