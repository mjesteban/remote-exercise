defmodule ExerciseWeb.SalaryControllerTest do
  use ExerciseWeb.ConnCase

  alias Mix.Tasks.Token
  alias Exercise.Countries

  @currency_attrs %{code: "PHP", name: "Philippine Peso", symbol: "₱"}
  @country_attrs %{code: "PHL", name: "Philippines"}
  @create_attrs %{
    full_name: "Mario Joseph",
    job_title: "Software Engineer",
    salary: "120.50"
  }
  @invalid_token "invalidtoken"

  def fixture(:currency) do
    {:ok, currency} = Countries.create_currency(@currency_attrs)
    currency
  end

  def fixture(:country) do
    currency = fixture(:currency)
    attrs = Map.put @country_attrs, :currency_id, currency.id
    {:ok, country} = Countries.create_country(attrs)
    country
  end

  def fixture(:employee) do
    currency = fixture(:currency)
    country = fixture(:country)
    attrs = Map.put @create_attrs, :currency_id, currency.id
    attrs = Map.put attrs, :country_id, country.id

    {:ok, employee} = Countries.create_employee(attrs)
    employee
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
    setup [:create_employee]

    test "show salary metrics on country name", %{conn: conn} do
      conn = get(conn, Routes.salary_path(conn, :index, "Philippines"))

      assert %{
               "country" => "Philippines",
               "average" => "120.50",
               "maximum" => "120.50",
               "minimum" => "120.50",
             } == json_response(conn, 200)["data"]
    end

    test "show salary metrics on country code", %{conn: conn} do
      conn = get(conn, Routes.salary_path(conn, :index, "PHL"))

      assert %{
               "country" => "Philippines",
               "average" => "120.50",
               "maximum" => "120.50",
               "minimum" => "120.50",
             } == json_response(conn, 200)["data"]
    end

    test "show salary metrics on job title", %{conn: conn} do
      conn = get(conn, Routes.salary_path(conn, :index, "Software Engineer"))

      assert %{
               "job_title" => "Software Engineer",
               "average" => "120.50",
             } == json_response(conn, 200)["data"]
    end

    test "renders error when bearer token is invalid", %{conn: conn} do
      conn = conn
        |> put_req_header("authorization", "Bearer #{@invalid_token}")
        |> get(Routes.salary_path(conn, :index, "Philippines"))
      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  defp create_employee(_) do
    employee = fixture(:employee)
    %{employee: employee}
  end

  def create_currency(_) do
    currency = fixture(:currency)
    %{currency: currency}
  end
end
