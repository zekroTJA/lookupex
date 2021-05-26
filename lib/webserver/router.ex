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

  if Application.get_env(:lookupex, :debug) do
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
    if conn.method == "OPTIONS" do
      conn |> resp_json_ok()
    else
      conn |> resp_json_not_found()
    end
  end
end
