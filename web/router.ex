defmodule DynamicRouting.Router do
  use DynamicRouting.Web, :router

  @external_resource "priv/wat.json"

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DynamicRouting do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/reload", ReloadController, :reload, as: :reload
  end

  dynamic_scopes = 
    "priv/wat.json"
    |> File.read!
    |> Poison.decode!
    |> IO.inspect
    |> Map.get("scopes")
    |> IO.inspect

  for {custom_scope, routes} <- dynamic_scopes do
    scope custom_scope do
      pipe_through :browser
      for [method, uri, controller, action] <- routes do
        match String.to_existing_atom(method), uri, String.to_existing_atom("Elixir." <> controller), String.to_existing_atom(action)
      end
    end
  end
  # Other scopes may use custom stacks.
  # scope "/api", DynamicRouting do
  #   pipe_through :api
  # end
end
