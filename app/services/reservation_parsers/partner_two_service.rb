# frozen_string_literal: true

module ReservationParsers
  class PartnerTwoService
    attr_accessor :formatted_data

    def initialize(data)
      self.formatted_data = format(data)
    end

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def format(data)
      { reservation: {
          code: data.dig('reservation', 'code'),
          start_date: data.dig('reservation', 'start_date'),
          end_date: data.dig('reservation', 'end_date'),
          security_price: data.dig('reservation', 'listing_security_price_accurate'),
          payout_amount: data.dig('reservation', 'expected_payout_amount'),
          total_paid: data.dig('reservation', 'total_paid_amount_accurate'),
          currency: data.dig('reservation', 'host_currency')&.downcase,
          status: data.dig('reservation', 'status_type')&.downcase,
          adults: data.dig('reservation', 'guest_details', 'number_of_adults'),
          children: data.dig('reservation', 'guest_details', 'number_of_children'),
          infants: data.dig('reservation', 'guest_details', 'number_of_infants'),
          notes: data.dig('reservation', 'guest_details', 'localized_description')
        },
        guest: {
          first_name: data.dig('reservation', 'guest_first_name'),
          last_name: data.dig('reservation', 'guest_last_name'),
          email: data.dig('reservation', 'guest_email'),
          phone: data.dig('reservation', 'guest_phone_numbers')
        } }
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize
  end
end
