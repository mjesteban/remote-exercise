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
    |> validate_required([:name, :code, :currency_id])
    |> validate_length(:name, max: 255)
    |> validate_format(
      :code, ~r/^[A-Z]{3}$/,
      message: "must be three characters and in ALL CAPS"
    )
    |> validate_format(
      :name, ~r/^[A-Z].*$/,
      message: "must be capitalized"
    )
    |> unique_constraint(:name)
    |> unique_constraint(:code)
    |> assoc_constraint(:currency)
  end
end
