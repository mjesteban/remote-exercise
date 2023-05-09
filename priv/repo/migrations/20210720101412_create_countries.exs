defmodule Exercise.Repo.Migrations.CreateCountries do
  use Ecto.Migration

  def change do
    create table(:countries) do
      add :name, :string, null: false, size: 255
      add :code, :string, null: false, size: 3
      add :currency_id, references(:currencies, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:countries, [:name])
    create unique_index(:countries, [:code])
    create index(:countries, [:currency_id])
  end
end
