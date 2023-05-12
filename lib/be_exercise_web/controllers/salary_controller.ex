defmodule ExerciseWeb.SalaryController do
  @moduledoc """
  The controller for Salary
  """
  use ExerciseWeb, :controller

  alias Exercise.Salaries

  action_fallback ExerciseWeb.FallbackController

  @doc """
    Retrieves salary metrics based on a filter.
  """
  def index(conn, %{"filter" => filter}) do
    salary = Salaries.get_salary_metrics!(filter)
    render(conn, "index.json", salary: salary)
  end

end
