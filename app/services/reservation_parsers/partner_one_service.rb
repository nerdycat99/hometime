# frozen_string_literal: true

module ReservationParsers
  class PartnerOneService
    attr_accessor :formatted_data

    def initialize(data)
      self.formatted_data = format(data)
      Rails.logger.debug BaseService.formatted_phone_numbers(nil).inspect
    end

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def format(data)
      { reservation: {
          code: data['reservation_code'],
          start_date: data['start_date'],
          end_date: data['end_date'],
          security_price: BaseService.formatted_price(data['security_price']),
          payout_amount: BaseService.formatted_price(data['payout_price']),
          total_paid: BaseService.formatted_price(data['total_price']),
          currency: data['currency']&.downcase,
          status: data['status']&.downcase,
          adults: data['adults'],
          children: data['children'],
          infants: data['infants'],
          notes: nil
        },
        guest: {
          first_name: data.dig('guest', 'first_name'),
          last_name: data.dig('guest', 'last_name'),
          email: data.dig('guest', 'email'),
          phone: BaseService.formatted_phone_numbers(data.dig('guest', 'phone'))
        } }
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize
  end
end
