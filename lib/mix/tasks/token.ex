defmodule Mix.Tasks.Token do

  def print() do
    token = get_value()
    IO.puts IO.ANSI.format([:inverse, :bright, :underline, token])
  end

  def get_value() do
    Phoenix.Token.sign(
      Application.get_env(:be_exercise, ExerciseWeb.Endpoint)[:secret_key_base],
      "asin",
      "some data"
    )
  end
end

Mix.Tasks.Token.print()
