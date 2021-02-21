defmodule Booking.Factory do
  use ExMachina.Ecto, repo: Booking.Repo

  # Factories
  def order_factory do
    %Booking.Orders.Order{
      balance_due: 429.65,
      total: 429.65,
      description: sequence("some description")
    }
  end
end
