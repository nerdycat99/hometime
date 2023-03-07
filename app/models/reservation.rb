# frozen_string_literal: true

class Reservation < ApplicationRecord
  enum currency: { aud: 0 }
  enum status: { cancelled: 0, pending: 1, accepted: 2 }

  belongs_to :guest

  validates :currency, inclusion: { in: currencies.keys }
  validates :status, inclusion: { in: statuses.keys }
  validates :code, :start_date, :end_date, presence: true
  validates :adults, presence: true, numericality: { greater_than_or_equal_to: 1, only_integer: true }
  # rubocop:disable Layout/LineLength
  validates :security_price, :payout_amount, :total_paid, :adults, :children, :infants, presence: true,
                                                                                        numericality: { greater_than_or_equal_to: 0, only_integer: true }
  # rubocop:enable Layout/LineLength

  def update_with(reservation_params)
    errors unless update(reservation_params)
  rescue ArgumentError => e
    e
  end
end
