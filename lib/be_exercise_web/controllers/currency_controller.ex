defmodule ExerciseWeb.CurrencyController do
  @moduledoc """
  The controller for Currency
  """
  use ExerciseWeb, :controller

  alias Exercise.Countries
  alias Exercise.Countries.Currency

  action_fallback ExerciseWeb.FallbackController

  @doc """
    Retrieves a list of currencies.
  """
  def index(conn, _params) do
    currencies = Countries.list_currencies()
    render(conn, "index.json", currencies: currencies)
  end

  @doc """
    Creates a new currency.
  """
  def create(conn, %{"currency" => currency_params}) do
    with {:ok, %Currency{} = currency} <- Countries.create_currency(currency_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.currency_path(conn, :show, currency))
      |> render("show.json", currency: currency)
    end
  end

  @doc """
    Retrieves a specific currency.
  """
  def show(conn, %{"id" => id}) do
    currency = Countries.get_currency!(id)
    render(conn, "show.json", currency: currency)
  end

  @doc """
    Updates an existing currency.
  """
  def update(conn, %{"id" => id, "currency" => currency_params}) do
    currency = Countries.get_currency!(id)

    with {:ok, %Currency{} = currency} <- Countries.update_currency(currency, currency_params) do
      render(conn, "show.json", currency: currency)
    end
  end

  @doc """
    Deletes a currency.
  """
  def delete(conn, %{"id" => id}) do
    currency = Countries.get_currency!(id)

    with {:ok, %Currency{}} <- Countries.delete_currency(currency) do
      send_resp(conn, :no_content, "")
    end
  end
end
