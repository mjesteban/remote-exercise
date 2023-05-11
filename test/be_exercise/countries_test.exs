defmodule Exercise.CountriesTest do
  use Exercise.DataCase

  alias Exercise.Countries

  describe "currencies" do
    alias Exercise.Countries.Currency

    @valid_attrs %{code: "PHP", name: "Philippine Peso", symbol: "₱"}
    @update_attrs %{
      code: "USD",
      name: "United States Dollar",
      symbol: "$"
    }
    @invalid_attrs %{code: nil, name: nil, symbol: nil}

    def currency_fixture(attrs \\ %{}) do
      {:ok, currency} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Countries.create_currency()

      currency
    end

    test "list_currencies/0 returns all currencies" do
      currency = currency_fixture()
      assert Countries.list_currencies() == [currency]
    end

    test "get_currency!/1 returns the currency with given id" do
      currency = currency_fixture()
      assert Countries.get_currency!(currency.id) == currency
    end

    test "create_currency/1 with valid data creates a currency" do
      assert {:ok, %Currency{} = currency} = Countries.create_currency(@valid_attrs)
      assert currency.code == @valid_attrs.code
      assert currency.name == @valid_attrs.name
      assert currency.symbol == @valid_attrs.symbol
    end

    test "create_currency/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Countries.create_currency(@invalid_attrs)
    end

    test "update_currency/2 with valid data updates the currency" do
      currency = currency_fixture()
      assert {:ok, %Currency{} = currency} = Countries.update_currency(currency, @update_attrs)
      assert currency.code == @update_attrs.code
      assert currency.name == @update_attrs.name
      assert currency.symbol == @update_attrs.symbol
    end

    test "update_currency/2 with invalid data returns error changeset" do
      currency = currency_fixture()
      assert {:error, %Ecto.Changeset{}} = Countries.update_currency(currency, @invalid_attrs)
      assert currency == Countries.get_currency!(currency.id)
    end

    test "delete_currency/1 deletes the currency" do
      currency = currency_fixture()
      assert {:ok, %Currency{}} = Countries.delete_currency(currency)
      assert_raise Ecto.NoResultsError, fn -> Countries.get_currency!(currency.id) end
    end

    test "change_currency/1 returns a currency changeset" do
      currency = currency_fixture()
      assert %Ecto.Changeset{} = Countries.change_currency(currency)
    end
  end

  describe "countries" do
    alias Exercise.Countries.Country

    @valid_attrs %{code: "PHL", name: "Philippines"}
    @update_attrs %{code: "USZ", name: "United Statez"}
    @invalid_attrs %{code: nil, name: nil}

    def country_fixture(attrs \\ %{}) do
      currency = currency_fixture()

      {:ok, country} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Enum.into(%{currency_id: currency.id})
        |> Countries.create_country()

      country
    end

    test "list_countries/0 returns all countries" do
      country = country_fixture()
      assert Countries.list_countries() == [country]
    end

    test "get_country!/1 returns the country with given id" do
      country = country_fixture()
      assert Countries.get_country!(country.id) == country
    end

    test "create_country/1 with valid data creates a country" do
      currency = currency_fixture()
      attrs = Map.put @valid_attrs, :currency_id, currency.id

      assert {:ok, %Country{} = country} = Countries.create_country(attrs)
      assert country.code == @valid_attrs.code
      assert country.name == @valid_attrs.name
    end

    test "create_country/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Countries.create_country(@invalid_attrs)
    end

    test "update_country/2 with valid data updates the country" do
      country = country_fixture()
      assert {:ok, %Country{} = country} = Countries.update_country(country, @update_attrs)
      assert country.code == @update_attrs.code
      assert country.name == @update_attrs.name
    end

    test "update_country/2 with invalid data returns error changeset" do
      country = country_fixture()
      assert {:error, %Ecto.Changeset{}} = Countries.update_country(country, @invalid_attrs)
      assert country == Countries.get_country!(country.id)
    end

    test "delete_country/1 deletes the country" do
      country = country_fixture()
      assert {:ok, %Country{}} = Countries.delete_country(country)
      assert_raise Ecto.NoResultsError, fn -> Countries.get_country!(country.id) end
    end

    test "change_country/1 returns a country changeset" do
      country = country_fixture()
      assert %Ecto.Changeset{} = Countries.change_country(country)
    end
  end

  # describe "employees" do
  #   alias Exercise.Countries.Employee

  #   @valid_attrs %{full_name: "some full_name", job_title: "some job_title", salary: "120.5", currency_id: 1, country_id: 1}
  #   @update_attrs %{full_name: "some updated full_name", job_title: "some updated job_title", salary: "456.7", currency_id: 2, country_id: 2}
  #   @invalid_attrs %{full_name: nil, job_title: nil, salary: nil, currency_id: 1, country_id:}

  #   def employee_fixture(attrs \\ %{}) do
  #     {:ok, employee} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Countries.create_employee()

  #     employee
  #   end

  #   test "list_employees/0 returns all employees" do
  #     employee = employee_fixture()
  #     assert Countries.list_employees() == [employee]
  #   end

  #   test "get_employee!/1 returns the employee with given id" do
  #     employee = employee_fixture()
  #     assert Countries.get_employee!(employee.id) == employee
  #   end

  #   test "create_employee/1 with valid data creates a employee" do
  #     assert {:ok, %Employee{} = employee} = Countries.create_employee(@valid_attrs)
  #     assert employee.full_name == @valid_attrs.full_name
  #     assert employee.job_title == @valid_attrs.job_title
  #     assert employee.salary == Decimal.new("120.5")
  #   end

  #   test "create_employee/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Countries.create_employee(@invalid_attrs)
  #   end

  #   test "update_employee/2 with valid data updates the employee" do
  #     employee = employee_fixture()
  #     assert {:ok, %Employee{} = employee} = Countries.update_employee(employee, @update_attrs)
  #     assert employee.full_name == "some updated full_name"
  #     assert employee.job_title == "some updated job_title"
  #     assert employee.salary == Decimal.new("456.7")
  #   end

  #   test "update_employee/2 with invalid data returns error changeset" do
  #     employee = employee_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Countries.update_employee(employee, @invalid_attrs)
  #     assert employee == Countries.get_employee!(employee.id)
  #   end

  #   test "delete_employee/1 deletes the employee" do
  #     employee = employee_fixture()
  #     assert {:ok, %Employee{}} = Countries.delete_employee(employee)
  #     assert_raise Ecto.NoResultsError, fn -> Countries.get_employee!(employee.id) end
  #   end

  #   test "change_employee/1 returns a employee changeset" do
  #     employee = employee_fixture()
  #     assert %Ecto.Changeset{} = Countries.change_employee(employee)
  #   end
  # end
end
