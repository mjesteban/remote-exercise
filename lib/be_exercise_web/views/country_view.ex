defmodule ExerciseWeb.CountryView do
  use ExerciseWeb, :view
  alias ExerciseWeb.{CountryView, CurrencyView}

  def render("index.json", %{countries: countries}) do
    %{data: render_many(countries, CountryView, "country_with_currency.json")}
  end

  def render("show.json", %{country: country}) do
    %{data: render_one(country, CountryView, "country_with_currency.json")}
  end

  def render("country.json", %{country: country}) do
    %{id: country.id, name: country.name, code: country.code}
  end

  def render("country_with_currency.json", %{country: country}) do
    %{
      id: country.id,
      name: country.name,
      code: country.code,
      currency: render_one(country.currency, CurrencyView, "currency.json")
    }
  end
end
