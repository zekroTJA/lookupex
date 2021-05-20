defmodule Lookupex.Webserver.Router do
  use Plug.Router
  use Plug.ErrorHandler
  require Logger
  import Lookupex.Webserver.Util

  plug(
    Plug.Parsers,
    parsers: [:json],
    pass: ["text/*"],
    json_decoder: Jason
  )

  # This is dirty, maybe find a better solution
  # for that later :)
  Envy.auto_load()

  if System.get_env("DEBUG", "false") |> String.downcase() == "true" do
    Logger.warn("debug mode engaged")
    plug(CORSPlug)
  end

  plug(:match)
  plug(:dispatch)

  get "/lookup/:id" do
    {data, status} = Lookupex.Discord.lookup(id)
    data |> resp_json(conn, status)
  end

  match _ do
    conn |> resp_json_not_found()
  end
end
