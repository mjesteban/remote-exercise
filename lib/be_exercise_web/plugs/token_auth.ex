defmodule ExerciseWeb.TokenAuth do
  @moduledoc """
  Authentication through a generated Phoenix.Token as a Bearer Token
  """
  use ExerciseWeb, :controller
  import Plug.Conn

  alias Phoenix.Token

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_bearer_token(conn) do
      nil ->
        conn |> unauthorized()
      token ->
        case verify_token(token) do
          {:ok, _} -> conn
          _ -> conn |> unauthorized()
        end
    end
  end

  defp verify_token(token) do
    Token.verify(
      Application.get_env(:be_exercise, ExerciseWeb.Endpoint)[:secret_key_base],
      "asin",
      token
    )
  end

  defp get_bearer_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> token
      _ -> nil
    end
  end

  defp unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ExerciseWeb.ErrorView)
    |> render(:"401")
    |> halt()
  end

end
