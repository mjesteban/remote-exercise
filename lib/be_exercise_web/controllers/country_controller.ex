defmodule ExerciseWeb.CountryController do
  @moduledoc """
  The controller for Country
  """
  use ExerciseWeb, :controller

  alias Exercise.Countries
  alias Exercise.Countries.Country

  action_fallback ExerciseWeb.FallbackController

  @doc """
    Retrieves a list of countries.
  """
  def index(conn, _params) do
    countries = Countries.list_countries()
    render(conn, "index.json", countries: countries)
  end

  @doc """
    Creates a new country
  """
  def create(conn, %{"country" => country_params}) do
    with {:ok, %Country{} = country} <- Countries.create_country(country_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.country_path(conn, :show, country))
      |> render("show.json", country: country)
    end
  end

  @doc """
    Retrieves a specific country.
  """
  def show(conn, %{"id" => id}) do
    country = Countries.get_country!(id)
    render(conn, "show.json", country: country)
  end

  @doc """
    Updates an existing country.
  """
  def update(conn, %{"id" => id, "country" => country_params}) do
    country = Countries.get_country!(id)

    with {:ok, %Country{} = country} <- Countries.update_country(country, country_params) do
      render(conn, "show.json", country: country)
    end
  end

  @doc """
    Deletes a country.
  """
  def delete(conn, %{"id" => id}) do
    country = Countries.get_country!(id)

    with {:ok, %Country{}} <- Countries.delete_country(country) do
      send_resp(conn, :no_content, "")
    end
  end
end
