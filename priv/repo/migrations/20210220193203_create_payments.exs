defmodule Booking.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :amount, :float, null: false
      add :applied_at, :timestamptz, null: false
      add :note, :text
      add :order_id, references(:orders, on_delete: :delete_all, type: :binary_id), null: false

      timestamps(type: :timestamptz)
    end

    create index(:payments, [:order_id])
  end
end
