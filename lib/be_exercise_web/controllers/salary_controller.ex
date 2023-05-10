defmodule ExerciseWeb.SalaryController do
  use ExerciseWeb, :controller

  alias Exercise.Countries

  action_fallback ExerciseWeb.FallbackController

  def show(conn, %{"filter" => filter}) do
    salary = Countries.get_salary_metrics!(filter)
    render(conn, "show.json", salary: salary)
  end

end
