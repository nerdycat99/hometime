# frozen_string_literal: true

module ReservationParsers
  class BaseService
    attr_accessor :params, :partner

    def self.formatted_phone_numbers(phone_numbers)
      phone_numbers.is_a?(Array) ? phone_numbers : phone_numbers&.split(',')
    end

    def self.formatted_price(price)
      (price.to_f * 100).to_i if price.present?
    end

    def initialize(params)
      self.params = params
      verify_partner
    end

    def verify_partner
      self.partner = if params['reservation_code'].present?
                       'partner_one'
                     elsif params.dig('reservation', 'code').present?
                       'partner_two'
                     end
    end

    def formatted_params
      case partner
      when 'partner_one'
        ReservationParsers::PartnerOneService.new(params).formatted_data
      when 'partner_two'
        ReservationParsers::PartnerTwoService.new(params).formatted_data
      end
    end
  end
end
