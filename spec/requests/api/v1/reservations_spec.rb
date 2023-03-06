# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Reservations', type: :request do
  let(:headers) { { CONTENT_TYPE: 'application/json' } }
  let(:other_params) do
    {
      reservation: {
        data: {
          code: '123456',
          start_date: '2021-03-12',
          end_date: '2021-03-16',
          expected_payout_amount: '3800.00'
        },
        guest_details: {
          localized_description: '4 guests',
          number_of_adults: 2,
          number_of_children: 2,
          number_of_infants: 0
        },
        guest_email: 'wayne_woodbridge@bnb.com'
      }
    }
  end
  let(:partner_one_params) do
    {
      reservation_code: 'YYY12345678',
      start_date: '2021-04-14',
      end_date: '2021-04-18',
      nights: 4,
      guests: 4,
      adults: 2,
      children: 2,
      infants: 0,
      status: 'accepted',
      guest: {
        first_name: 'Wayne',
        last_name: 'Woodbridge',
        phone: '639123456789',
        email: 'wayne_woodbridge@bnb.com'
      },
      currency: 'AUD',
      payout_price: '4200.00',
      security_price: '500.0',
      total_price: '4700.0'
    }
  end
  let(:partner_two_params) do
    {
      reservation: {
        code: '123456',
        start_date: '2021-03-12',
        end_date: '2021-03-16',
        expected_payout_amount: '3800.00',
        guest_details: {
          localized_description: '4 guests',
          number_of_adults: 2,
          number_of_children: 2,
          number_of_infants: 0
        },
        guest_email: 'wayne_woodbridge@bnb.com',
        guest_first_name: 'Wayne',
        guest_last_name: 'Woodbridge',
        guest_phone_numbers: %w[
          639123456789
          639123456789
        ],
        listing_security_price_accurate: '500.00',
        host_currency: 'AUD',
        nights: 4,
        number_of_guests: 4,
        status_type: 'accepted',
        total_paid_amount_accurate: '4300.00'
      }
    }
  end

  before { host! 'api.example.com' }

  describe 'POST /api_v1_reservations' do
    context 'with params that match a submitting partner ' do
      context 'for partner one' do
        it 'returns a success response' do
          post api_v1_reservations_path(params: partner_one_params, headers:)
          expect(response).to be_successful
        end
      end
      context 'for partner two' do
        it 'returns a success response' do
          post api_v1_reservations_path(params: partner_two_params, headers:)
          expect(response).to be_successful
        end
      end
    end
    context 'with params that do not match a submitting partner ' do
      it 'returns a bad request response' do
        post api_v1_reservations_path(params: other_params, headers:)
        expect(response.status).to eq(400)
      end
    end
  end
end
