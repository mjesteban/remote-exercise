defmodule ExerciseWeb.EmployeeController do
  use ExerciseWeb, :controller

  alias Exercise.Countries
  alias Exercise.Countries.Employee

  action_fallback ExerciseWeb.FallbackController

  def index(conn, _params) do
    employees = Countries.list_employees()
    render(conn, "index.json", employees: employees)
  end

  def create(conn, %{"employee" => employee_params}) do
    with {:ok, %Employee{} = employee} <- Countries.create_employee(employee_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.employee_path(conn, :show, employee))
      |> render("show.json", employee: employee)
    end
  end

  def show(conn, %{"id" => id}) do
    employee = Countries.get_employee!(id)
    render(conn, "show.json", employee: employee)
  end

  def update(conn, %{"id" => id, "employee" => employee_params}) do
    employee = Countries.get_employee!(id)

    with {:ok, %Employee{} = employee} <- Countries.update_employee(employee, employee_params) do
      render(conn, "show.json", employee: employee)
    end
  end

  def delete(conn, %{"id" => id}) do
    employee = Countries.get_employee!(id)

    with {:ok, %Employee{}} <- Countries.delete_employee(employee) do
      send_resp(conn, :no_content, "")
    end
  end
end
