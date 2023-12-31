defmodule Exercise.Countries.Currency do
  alias Exercise.Countries.{Country, Employee}
  use Ecto.Schema
  import Ecto.Changeset

  schema "currencies" do
    field :code, :string
    field :name, :string
    field :symbol, :string
    has_many :countries, Country
    has_many :employees, Employee

    timestamps()
  end

  @doc false
  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:code, :name, :symbol])
    |> validate_required([:code, :name, :symbol])
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
  end
end
