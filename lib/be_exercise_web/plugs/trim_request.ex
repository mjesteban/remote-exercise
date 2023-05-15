defmodule ExerciseWeb.TrimRequest do
  def init(opts), do: opts

  def call(%Plug.Conn{params: params_map, method: method} = conn, _opts)
    when method in ["POST", "PUT", "PATCH"]
  do
    #get they key
    [{key, _}] = Map.to_list(params_map)

    trim_values = Enum.map(
      params_map[key],
      fn {key, value} -> {key,
        case is_binary(value) do
          true -> String.trim(value)
          _ -> value
        end
      }
    end)
    |> Enum.into(%{})
    trimmed_map = Map.put params_map, key, trim_values

    conn = %{conn | params: trimmed_map}
    conn
  end
end
