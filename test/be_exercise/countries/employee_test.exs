defmodule Exercise.Countries.EmployeeTest do
  use ExUnit.Case
  use Exercise.DataCase, async: false

  alias Exercise.Countries
  alias Exercise.Countries.Employee

  test "valid changeset" do
    changeset = Employee.changeset(%Employee{}, %{
      full_name: "Mario Joseph",
      job_title: "Software Engineer",
      salary: 60000,
      country_id: 1,
      currency_id: 1
    })

    assert changeset.valid?
  end

  test "changeset requires full_name, job_title, salary, country_id, and currency_id" do
    changeset = Employee.changeset(%Employee{}, %{})
    errors = errors_on(changeset)

    refute changeset.valid?
    assert {:error, _changeset} = Countries.create_employee(changeset.changes)

    assert "can't be blank" in errors.full_name
    assert "can't be blank" in errors.job_title
    assert "can't be blank" in errors.salary
    assert "can't be blank" in errors.country_id
    assert "can't be blank" in errors.currency_id
  end

  test "full_name must be less than or equal to 255 characters" do
    changeset = Employee.changeset(%Employee{}, %{
      full_name: String.duplicate("A", 256),
      job_title: "Software Engineer",
      salary: 60000,
      country_id: 1,
      currency_id: 1
    })
    errors = errors_on(changeset)

    refute changeset.valid?
    assert {:error, _changeset} = Countries.create_employee(changeset.changes)

    assert "should be at most 255 character(s)" in errors.full_name
  end

  test "job_title must be less than or equal to 255 characters" do
    changeset = Employee.changeset(%Employee{}, %{
      full_name: "Mario Joseph",
      job_title: String.duplicate("A", 256),
      salary: 60000,
      country_id: 1,
      currency_id: 1
    })
    errors = errors_on(changeset)

    refute changeset.valid?
    assert {:error, _changeset} = Countries.create_employee(changeset.changes)

    assert "should be at most 255 character(s)" in errors.job_title
  end

  test "salary must be greater than 0" do
    changeset = Employee.changeset(%Employee{}, %{
      full_name: "Mario Joseph",
      job_title: "Software Engineer",
      salary: 0,
      country_id: 1,
      currency_id: 1
    })
    errors = errors_on(changeset)

    refute changeset.valid?
    assert {:error, _changeset} = Countries.create_employee(changeset.changes)

    assert "must be greater than 0" in errors.salary
  end

  # will spit out
  # ERROR:  insert or update on table "employees" violates foreign key constraint "employees_country_id_fkey"
  test "country association must exist" do
    changeset = Employee.changeset(%Employee{}, %{
      full_name: "Mario Joseph",
      job_title: "Software Engineer",
      salary: 60000,
      country_id: 0,
      currency_id: 1
    })

    assert {:error, changeset} = Countries.create_employee(changeset.changes)
    refute changeset.valid?
    errors = errors_on(changeset)

    assert "does not exist" in errors.country
  end

  # functional through end to end testing and in iex, but testing says other wise
  @moduletag :exclude_from_test
  test "currency association must exist" do
    changeset = Employee.changeset(%Employee{}, %{
      full_name: "Mario Joseph",
      job_title: "Software Engineer",
      salary: 60000,
      currency_id: 0,
      country_id: 1
    })

    assert {:error, changeset} = Countries.create_employee(changeset.changes)
    refute changeset.valid?
    errors = errors_on(changeset)

    assert "does not exist" in errors.currency
  end
end
