defmodule Exercise.Salaries do
  @moduledoc """
  The Salaries context.
  """

  import Ecto.Query, warn: false
  alias Exercise.Repo
  alias Exercise.Countries.{Country, Employee}

  @doc """
  Retrieves salary metrics based on the provided filter either a country code or name OR a job tittle.

  ## Examples

      iex> get_salary_metrics!("United States")
      %{
        average: #Decimal<521028.78>,
        country: "United States",
        maximum: #Decimal<999000.00>,
        minimum: #Decimal<1000.00>
      }

      iex> get_salary_metrics!("USA")
      %{
        average: #Decimal<521028.78>,
        country: "United States",
        maximum: #Decimal<999000.00>,
        minimum: #Decimal<1000.00>
      }

      iex> Salaries.get_salary_metrics!("Software Engineer")
      %{average: #Decimal<523942.86>, job_title: "Software Engineer"}

      iex> get_salary_metrics!("usa")
      ** (Ecto.NoResultsError)

      iex> get_salary_metrics!("software engineer")
      ** (Ecto.NoResultsError)

  """
  def get_salary_metrics!(filter) do
    case filter_as_atom(filter) do
      :country ->
        filter
        |> query_for_country()
        |> Repo.one!()
      :job_title ->
        filter
        |> query_for_job_title()
        |> Repo.one!()
    end
  end

  defp query_for_country(country) do
    from e in Employee,
      join: c in Country,
      on: c.id == e.country_id,
      where: c.name == ^country or c.code == ^country,
      select: %{
        country: c.name,
        minimum: min(e.salary),
        maximum: max(e.salary),
        average: fragment("ROUND(AVG(?), 2)", e.salary)
      },
      group_by: c.name
  end

  defp query_for_job_title(job_title) do
    from e in Employee,
      where: e.job_title == ^job_title,
      select: %{
        job_title: e.job_title,
        average: fragment("ROUND(AVG(?), 2)", e.salary)
      },
      group_by: e.job_title
  end

  defp filter_as_atom(filter) do
    case Repo.one(
      from c in Country,
        where: c.name == ^filter or c.code == ^filter
    ) do
      nil -> :job_title
      _ -> :country
    end
  end
end
