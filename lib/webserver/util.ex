defmodule Lookupex.Webserver.Util do
  import Plug.Conn

  @moduledoc """
  Module that provides some basic functionalities
  for sending and responding to HTTP requests.
  """

  defmodule Error do
    @moduledoc """
    A struct wrapping an error repsonse
    object containing a `code` and an
    error `message`.
    """

    @type t() :: %__MODULE__{
            code: integer(),
            message: String.t()
          }

    @derive Jason.Encoder
    defstruct code: 0, message: ""
  end

  @doc """
  Respond with the passed `object` as JSON
  body content and `status` as response
  status code.
  """
  def resp_json(object, conn, status \\ 200) do
    conn
    |> put_resp_content_type("application/json", "utf-8")
    |> send_resp(status, Jason.encode!(object))
  end

  @doc """
  Respond with a JSON parsed `err` object
  wrapping the error code (equals status code)
  and an error message.
  """
  def resp_json_error(err, conn) do
    err
    |> resp_json(conn, err.code)
  end

  def resp_json_error(conn, code, message) do
    %Error{
      code: code,
      message: message
    }
    |> resp_json_error(conn)
  end

  @doc """
  Wraps `resp_json_error/2` with a predefined
  404 not found error object.
  """
  def resp_json_not_found(conn),
    do:
      %Error{code: 404, message: "not found"}
      |> resp_json_error(conn)

  @doc """
  Wraps `resp_json_error/2` with a predefined
  401 unauthorized error object.
  """
  def resp_json_unauthorized(conn),
    do:
      %Error{code: 401, message: "unauthorized"}
      |> resp_json_error(conn)

  @doc """
  Sends a 200 OK response with the defined content
  object or a default predefined ok object.
  """
  def resp_json_ok(data \\ %{code: 200, message: "ok"}, conn),
    do: data |> resp_json(conn, 200)
end
