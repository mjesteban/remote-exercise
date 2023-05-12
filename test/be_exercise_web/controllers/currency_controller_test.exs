defmodule ExerciseWeb.CurrencyControllerTest do
  use ExerciseWeb.ConnCase

  alias Mix.Tasks.Token
  alias Exercise.Countries
  alias Exercise.Countries.Currency

  @create_attrs %{
    code: "PHP",
    name: "Philippine Peso",
    symbol: "₱"
  }
  @update_attrs %{
    code: "USD",
    name: "United States Dollar",
    symbol: "$"
  }
  @invalid_attrs %{code: nil, name: nil, symbol: nil}
  @invalid_token "invalidtoken"

  def fixture(:currency) do
    {:ok, currency} = Countries.create_currency(@create_attrs)
    currency
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
    test "lists all currencies", %{conn: conn} do
      conn = get(conn, Routes.currency_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end

    test "renders error when bearer token is invalid", %{conn: conn} do
      conn = conn
        |> put_req_header("authorization", "Bearer #{@invalid_token}")
        |> get(Routes.currency_path(conn, :index))
      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  describe "create currency" do
    test "renders currency when data is valid", %{conn: conn} do
      conn = post(conn, Routes.currency_path(conn, :create), currency: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.currency_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "code" => "PHP",
               "name" => "Philippine Peso",
               "symbol" => "₱"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.currency_path(conn, :create), currency: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders error when bearer token is invalid", %{conn: conn} do
      conn = conn
        |> put_req_header("authorization", "Bearer #{@invalid_token}")
        |> post(Routes.currency_path(conn, :create), currency: @create_attrs)
      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  describe "update currency" do
    setup [:create_currency]

    test "renders currency when data is valid", %{
      conn: conn,
      currency: %Currency{id: id} = currency
    } do
      conn = put(conn, Routes.currency_path(conn, :update, currency), currency: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.currency_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "code" => "USD",
               "name" => "United States Dollar",
               "symbol" => "$"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, currency: currency} do
      conn = put(conn, Routes.currency_path(conn, :update, currency), currency: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders error when bearer token is invalid", %{conn: conn, currency: currency} do
      conn = conn
        |> put_req_header("authorization", "Bearer #{@invalid_token}")
        |> put(Routes.currency_path(conn, :update, currency), currency: @update_attrs)
      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  describe "delete currency" do
    setup [:create_currency]

    test "deletes chosen currency", %{conn: conn, currency: currency} do
      conn = delete(conn, Routes.currency_path(conn, :delete, currency))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.currency_path(conn, :show, currency))
      end
    end

    test "renders error when bearer token is invalid", %{conn: conn, currency: currency} do
      conn = conn
        |> put_req_header("authorization", "Bearer #{@invalid_token}")
        |> delete(Routes.currency_path(conn, :delete, currency))
      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  defp create_currency(_) do
    currency = fixture(:currency)
    %{currency: currency}
  end
end
