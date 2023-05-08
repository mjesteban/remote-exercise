defmodule ExerciseWeb.EmployeeView do
  use ExerciseWeb, :view
  alias ExerciseWeb.EmployeeView

  def render("index.json", %{employees: employees}) do
    %{data: render_many(employees, EmployeeView, "employee.json")}
  end

  def render("show.json", %{employee: employee}) do
    %{data: render_one(employee, EmployeeView, "employee.json")}
  end

  def render("employee.json", %{employee: employee}) do
    %{id: employee.id,
      full_name: employee.full_name,
      job_title: employee.job_title,
      salary: employee.salary}
  end
end
