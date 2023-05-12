defmodule Mix.Tasks.Token do
  @moduledoc """
  Generates a token using Phoenix.Token and can be utilized as a Bearer token in the request header.
  """

  @doc """
  Prints the Bearer token in a contrasting background.
  """
  def print() do
    token = get_value()
    IO.puts IO.ANSI.format([:inverse, :bright, :underline, token])
  end

  @doc """
  Generates the Bearer token via Phoenix.Token
  """
  def get_value() do
    Phoenix.Token.sign(
      Application.get_env(:be_exercise, ExerciseWeb.Endpoint)[:secret_key_base],
      "asin",
      "some data"
    )
  end
end

Mix.Tasks.Token.print()
