# frozen_string_literal: true

class Reservation < ApplicationRecord
  enum currency: { aud: 0 }
  enum status: { cancelled: 0, pending: 1, accepted: 2 }

  belongs_to :guest
end
