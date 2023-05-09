defmodule Exercise.Repo.Migrations.CreateEmployees do
  use Ecto.Migration

  def change do
    create table(:employees) do
      add :full_name, :string, null: false, size: 255
      add :job_title, :string, null: false, size: 255
      add :salary, :decimal, null: false, precision: 10, scale: 2
      add :country_id, references(:countries, on_delete: :nothing), null: false
      add :currency_id, references(:currencies, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:employees, [:country_id])
    create index(:employees, [:currency_id])
  end
end
