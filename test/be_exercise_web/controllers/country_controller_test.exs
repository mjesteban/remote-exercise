defmodule ExerciseWeb.CountryControllerTest do
  use ExerciseWeb.ConnCase

  alias Mix.Tasks.Token
  alias Exercise.Countries
  alias Exercise.Countries.{Country, Currency}

  @currency_attrs %{code: "PHP", name: "Philippine Peso", symbol: "₱"}
  @create_attrs %{code: "PHL", name: "Philippines"}
  @update_attrs %{code: "USZ", name: "United Statez"}
  @invalid_attrs %{code: nil, name: nil}
  @invalid_token "invalidtoken"

  def fixture(:currency) do
    {:ok, currency} = Countries.create_currency(@currency_attrs)
    currency
  end

  def fixture(:country) do
    currency = fixture(:currency)
    attrs = Map.put @create_attrs, :currency_id, currency.id
    {:ok, country} = Countries.create_country(attrs)
    country
  end

  setup %{conn: conn} do
    token = Token.get_value()

    # meh, merge_req_header is not yet available in Plug v1.11.1
    conn = conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer #{token}")
    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all countries", %{conn: conn} do
      conn = get(conn, Routes.country_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end

    test "renders error when bearer token is invalid", %{conn: conn} do
      conn = conn
        |> put_req_header("authorization", "Bearer #{@invalid_token}")
        |> get(Routes.country_path(conn, :index))
      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  describe "create country" do
    setup [:create_currency]

    test "renders country when data is valid", %{
      conn: conn,
      currency: %Currency{id: currency_id}
    } do
      attrs = Map.put @create_attrs, :currency_id, currency_id
      conn = post(conn, Routes.country_path(conn, :create), country: attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.country_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "code" => "PHL",
               "name" => "Philippines"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.country_path(conn, :create), country: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders error when bearer token is invalid", %{conn: conn, currency: %Currency{id: currency_id}} do
      attrs = Map.put @create_attrs, :currency_id, currency_id
      conn = conn
        |> put_req_header("authorization", "Bearer #{@invalid_token}")
        |> post(Routes.country_path(conn, :create), country: attrs)
      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  describe "update country" do
    setup [:create_country]

    test "renders country when data is valid", %{conn: conn, country: %Country{id: id} = country} do
      conn = put(conn, Routes.country_path(conn, :update, country), country: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.country_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "code" => "USZ",
               "name" => "United Statez"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, country: country} do
      conn = put(conn, Routes.country_path(conn, :update, country), country: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders error when bearer token is invalid", %{conn: conn, country: %Country{} = country} do
      conn = conn
        |> put_req_header("authorization", "Bearer #{@invalid_token}")
        |> put(Routes.country_path(conn, :update, country), country: @update_attrs)
      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  describe "delete country" do
    setup [:create_country]

    test "deletes chosen country", %{conn: conn, country: country} do
      conn = delete(conn, Routes.country_path(conn, :delete, country))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.country_path(conn, :show, country))
      end
    end

    test "renders error when bearer token is invalid", %{conn: conn, country: country} do
      conn = conn
        |> put_req_header("authorization", "Bearer #{@invalid_token}")
        |> delete(Routes.country_path(conn, :delete, country))
      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  defp create_country(_) do
    country = fixture(:country)
    %{country: country}
  end

  def create_currency(_) do
    currency = fixture(:currency)
    %{currency: currency}
  end
end
