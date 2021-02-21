defmodule Booking.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :text
      add :total, :float, null: false
      add :balance_due, :float, null: false

      timestamps(type: :timestamptz)
    end
  end
end
