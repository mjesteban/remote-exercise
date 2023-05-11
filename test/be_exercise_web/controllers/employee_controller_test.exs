defmodule ExerciseWeb.EmployeeControllerTest do
  use ExerciseWeb.ConnCase

  alias Exercise.Countries
  alias Exercise.Countries.{Currency, Country, Employee}

  @currency_attrs %{code: "PHP", name: "Philippine Peso", symbol: "₱"}
  @country_attrs %{code: "PHL", name: "Philippines"}
  @create_attrs %{
    full_name: "Mario Joseph",
    job_title: "Software Engineer",
    salary: "120.50"
  }
  @update_attrs %{
    full_name: "Mario Joseph II",
    job_title: "Senior Software Engineer",
    salary: "456.70"
  }
  @invalid_attrs %{full_name: nil, job_title: nil, salary: nil}

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
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all employees", %{conn: conn} do
      conn = get(conn, Routes.employee_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create employee" do
    setup [:create_currency]
    setup [:create_country]

    test "renders employee when data is valid", %{
      conn: conn,
      currency: %Currency{id: currency_id},
      country: %Country{id: country_id}
    } do
      attrs = Map.put @create_attrs, :currency_id, currency_id
      attrs = Map.put attrs, :country_id, country_id
      conn = post(conn, Routes.employee_path(conn, :create), employee: attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.employee_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "full_name" => "Mario Joseph",
               "job_title" => "Software Engineer",
               "salary" => "120.50"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.employee_path(conn, :create), employee: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update employee" do
    setup [:create_employee]

    test "renders employee when data is valid", %{conn: conn, employee: %Employee{id: id} = employee} do
      conn = put(conn, Routes.employee_path(conn, :update, employee), employee: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.employee_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "full_name" => "Mario Joseph II",
               "job_title" => "Senior Software Engineer",
               "salary" => "456.70"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, employee: employee} do
      conn = put(conn, Routes.employee_path(conn, :update, employee), employee: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete employee" do
    setup [:create_employee]

    test "deletes chosen employee", %{conn: conn, employee: employee} do
      conn = delete(conn, Routes.employee_path(conn, :delete, employee))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.employee_path(conn, :show, employee))
      end
    end
  end

  defp create_employee(_) do
    employee = fixture(:employee)
    %{employee: employee}
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
