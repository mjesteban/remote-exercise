# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Exercise.Repo.insert!(%Exercise.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Exercise.Countries

# Seed the 8 supported currencies
# Euro (EUR)
# UK Pound Sterling (GBP)
# Australian Dollar (AUD)
# New Zealand Dollar (NZD)
# Unites States Dollar (USD)
# Canadian Dollar (CAD)
# Swiss Franc (CHF)
# Japanese Yen (JPY)
currency_data = [
  ["European Euro", "EUR", "€"],
  ["United Kingdom Pound Sterling", "GBP", "£"],
  ["Australian Dollar", "AUD", "$"],
  ["New Zealand Dollar", "NZD", "$"],
  ["United States Dollar", "USD", "$"],
  ["Canadian Dollar", "CAD", "$"],
  ["Swiss Franc", "CHF", "¥"],
  ["Japanese Yen", "JPY", "CHF"]
]

for currency <- currency_data do
  [name, code, symbol] = currency

  {:ok, _currency} = Countries.create_currency(%{
    name: name,
    code: code,
    symbol: symbol
  })
end

# Seed the 12 supported countries
country_data = [
  ["Australia", "AUS", "AUD"],
  ["Canada", "CAN", "CAD"],
  ["France", "FRA", "EUR"],
  ["Japan", "JPN", "JPY"],
  ["Italy", "ITA", "EUR"],
  ["Liechtenstein", "LIE", "CHF"],
  ["New Zealand", "NZL", "NZD"],
  ["Portugal", "PRT", "EUR"],
  ["Spain", "ESP", "EUR"],
  ["Switzerland", "CHE", "CHF"],
  ["United Kingdom", "GBR", "GBP"],
  ["United States", "USA", "USD"]
]

for country <- country_data do
  [name, code, currency_code] = country
  currency = Countries.get_currency_by_code!(currency_code)

  {:ok, _country} = Countries.create_country(%{
    name: name,
    code: code,
    currency_id: currency.id
  })
end

defmodule Employee.Seeds do
  @moduledoc """
  Employee seeder
  """

  alias Exercise.Repo
  alias Exercise.Countries.{Currency, Country, Employee}

  @doc """
  Seeds 10,000 employees from text files.
  - Full name: concatenated random first name and last name
  - Job Title: randomly select 100 job titles
  - Salary: randomly generate 1-1000 multiplied by 1000
  - Country ID: randomly picked from database
  - Currency ID: randomly picked from database
  """
  def main do
    job_title = build_job_titles()
    country_ids = build_ids(Country)
    currency_ids = build_ids(Currency)

    Repo.transaction(fn ->
      for _ <- 1..10000 do
        %Employee{}
        |> Employee.changeset(%{
          full_name: build_full_name(),
          job_title: Enum.random(job_title),
          salary: generate_salary(),
          country_id: Enum.random(country_ids),
          currency_id: Enum.random(currency_ids)
        })
        |> Repo.insert!()
      end
    end)
  end

  defp file_to_list(filename) do
    File.stream!("priv/data/#{filename}.txt")
    |> Enum.map(&String.trim(&1))
  end

  defp build_full_name do
    first_name = file_to_list("first_names") |> Enum.random()
    last_name = file_to_list("last_names") |> Enum.random()
    "#{first_name} #{last_name}"
  end

  defp build_job_titles() do
    file_to_list("job_titles")
    |> Enum.shuffle()
    |> Enum.take(100)
  end

  defp generate_salary(), do: 1000 * (:rand.uniform(1000))

  defp build_ids(resource), do: Repo.all(resource) |> Enum.map(&(&1.id))
end

Employee.Seeds.main()
