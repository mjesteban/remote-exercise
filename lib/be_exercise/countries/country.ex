defmodule Exercise.Countries.Country do
  alias Exercise.Countries.{Currency, Employee}
  use Ecto.Schema
  import Ecto.Changeset

  schema "countries" do
    field :code, :string
    field :name, :string
    belongs_to :currency, Currency
    has_many :employees, Employee

    timestamps()
  end

  @doc false
  def changeset(country, attrs) do
    country
    |> cast(attrs, [:name, :code, :currency_id])
    |> assoc_constraint(:currency)
    |> unique_constraint(:name)
    |> unique_constraint(:code)
    |> validate_required([:name, :code])
    |> validate_length(:name, max: 255)
    |> validate_format(:code, ~r/^[A-Z]{3}$/)
  end
end
