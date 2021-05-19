defmodule Lookupex.Webserver.Router do
  use Plug.Router
  use Plug.ErrorHandler

  import Lookupex.Webserver.Util

  plug(
    Plug.Parsers,
    parsers: [:json],
    pass: ["text/*"],
    json_decoder: Jason
  )

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
