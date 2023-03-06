# frozen_string_literal: true

require 'json'

class Guest < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :first_name, :last_name, :phone, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
