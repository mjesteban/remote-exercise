defmodule ExerciseWeb.TrimRequest do
  def init(opts), do: opts

  def call(%Plug.Conn{params: params_map} = conn, _opts) do

    #todo: only do trimming on POST, PUT, and PATCH methods

    #get they key
    [{key, _}] = Map.to_list(params_map)

    trim_values = Enum.map(
      params_map[key],
      fn {key, value} ->
        {key, String.trim(value)}
    end)
    |> Enum.into(%{})
    trimmed_map = Map.put params_map, key, trim_values

    conn = %{conn | params: trimmed_map}
    conn
  end
end
