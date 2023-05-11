defmodule Exercise.Countries.Employee do
  alias Exercise.Countries.{Country, Currency}
  use Ecto.Schema
  import Ecto.Changeset

  schema "employees" do
    field :full_name, :string
    field :job_title, :string
    field :salary, :decimal
    belongs_to :country, Country
    belongs_to :currency, Currency

    timestamps()
  end

  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:full_name, :job_title, :salary, :country_id, :currency_id])
    |> validate_required([:full_name, :job_title, :salary, :country_id, :currency_id])
    |> validate_length(:full_name, max: 255)
    |> validate_length(:job_title, max: 255)
    |> validate_format(
      :job_title, ~r/^[A-Z].*$/,
      message: "must be capitalized"
    )
    |> validate_number(:salary, greater_than: 1)
    |> assoc_constraint(:country)
    |> assoc_constraint(:currency)
  end
end
