defmodule Exercise.Repo.Migrations.CreateCurrencies do
  use Ecto.Migration

  def change do
    create table(:currencies) do
      add :code, :string, null: false, size: 3
      add :name, :string, null: false, size: 255
      add :symbol, :string, null: false, size: 3

      timestamps()
    end

    create unique_index(:currencies, [:code])
    create unique_index(:currencies, [:name])
  end
end
