# frozen_string_literal: true

class Reservation < ApplicationRecord
  enum currency: { aud: 0 }
  enum status: { cancelled: 0, pending: 1, accepted: 2 }

  belongs_to :guest

  validates :currency, inclusion: { in: currencies.keys }
  validates :status, inclusion: { in: statuses.keys }
  validates :code, presence: true
  validates :adults, presence: true, numericality: { greater_than_or_equal_to: 1, only_integer: true }
  # rubocop:disable Layout/LineLength
  validates :security_price, :payout_amount, :total_paid, :adults, :children, :infants, presence: true,
                                                                                        numericality: { greater_than_or_equal_to: 0, only_integer: true }
  # rubocop:enable Layout/LineLength
  validate :start_and_end__dates

  def start_and_end__dates
    error_message = if start_date.blank? || start_date < Date.current
                      'cannot be blank or in the past'
                    elsif end_date.blank? || end_date <= start_date
                      'cannot be blank or have a start date before the end date'
                    end
    errors.add :start_date, error_message if error_message.present?
  end

  def update_with(reservation_params)
    errors unless update(reservation_params)
  rescue ArgumentError => e
    e
  end
end
