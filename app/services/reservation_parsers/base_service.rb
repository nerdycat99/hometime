# frozen_string_literal: true

module ReservationParsers
  class BaseService
    attr_accessor :params, :partner

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
