defmodule ExerciseWeb.SalaryView do
  use ExerciseWeb, :view
  alias ExerciseWeb.SalaryView

  def render("index.json", %{salary: salary}) do
    %{data: render_one(salary, SalaryView, "salary.json")}
  end

  def render("salary.json", %{salary: %{country: _}} = %{salary: salary}) do
    %{
      country: salary.country,
      maximum: salary.maximum,
      minimum: salary.minimum,
      average: salary.average
    }
  end

  def render("salary.json", %{salary: %{job_title: _}} = %{salary: salary}) do
    %{
      job_title: salary.job_title,
      average: salary.average
    }
  end
end
