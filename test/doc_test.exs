defmodule Exercise.DocTest do
  use ExUnit.Case
  doctest Exercise.Services.CurrencyConverter, import: true
end
