# frozen_string_literal: true

require 'json'

class Guest < ApplicationRecord
  has_many :reservations, dependent: :destroy
end
