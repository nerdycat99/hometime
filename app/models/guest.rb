# frozen_string_literal: true

require 'json'

class Guest < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :first_name, :last_name, :phone, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def update_or_create_reservation(reservation_params)
    existing_reservation = Reservation.find_by(code: reservation_params[:code])
    if existing_reservation.present?
      return 'Reservation details provided are for another guest' if existing_reservation.guest != self

      existing_reservation.update_with(reservation_params)
    else
      create_reservation(reservation_params)
    end
  end

  private

  def create_reservation(reservation_params)
    Guest.transaction do
      begin
        reservation = reservations.new(reservation_params)
        next reservation.errors unless reservation.save
      rescue ArgumentError => e
        next e
      end
      next errors if !persisted? && !save
    end
  end
end
