# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Reservations', type: :request do
  let(:headers) { { CONTENT_TYPE: 'application/json' } }
  let(:other_params) do
    {
      reservation: {
        data: {
          code: '123456',
          start_date: '2025-03-12',
          end_date: '2025-03-16',
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
  let(:reservation_code) { 'YYY12345678' }
  let(:adults) { 2 }
  let(:start_date) { '2025-04-14' }
  let(:status) { 'accepted' }
  let(:currency) { 'AUD' }
  let(:email) { 'wayne_woodbridge@bnb.com' }
  let(:partner_one_params) do
    {
      reservation_code:,
      start_date:,
      end_date: '2025-04-18',
      nights: 4,
      guests: 4,
      adults:,
      children: 2,
      infants: 0,
      status:,
      guest: {
        first_name: 'Wayne',
        last_name: 'Woodbridge',
        phone: '639123456789',
        email:
      },
      currency:,
      payout_price: '4200.00',
      security_price: '500.0',
      total_price: '4700.0'
    }
  end
  let(:partner_two_params) do
    {
      reservation: {
        code: '123456',
        start_date: '2025-03-12',
        end_date: '2025-03-16',
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
      context 'with params that do not match a submitting partner ' do
        it 'returns a bad request response' do
          post api_v1_reservations_path(params: other_params, headers:)
          expect(response.status).to eq(400)
        end
      end
    end

    describe 'with missing or bad params' do
      context 'with an empty reservation code' do
        let(:reservation_code) { nil }
        it 'returns an error message' do
          post api_v1_reservations_path(params: partner_one_params, headers:)
          resp = response.parsed_body
          expect(resp['message']).to eq('There was a problem with the format of your request')
          expect(response.status).to eq(400)
        end
      end
      context 'without adults on a booking request' do
        let(:adults) { 0 }
        it 'returns an error message' do
          post api_v1_reservations_path(params: partner_one_params, headers:)
          resp = response.parsed_body
          expect(resp.dig('errors', 'adults').first).to eq('must be greater than or equal to 1')
          expect(response.status).to eq(422)
        end
      end
      context 'with invalid date' do
        let(:start_date) { 0 }
        it 'returns an error message' do
          post api_v1_reservations_path(params: partner_one_params, headers:)
          resp = response.parsed_body
          expect(resp.dig('errors', 'start_date').first).to eq('cannot be blank or in the past')
          expect(response.status).to eq(422)
        end
      end
      context 'with status that is not a valid enum' do
        let(:status) { 'something' }
        it 'returns an error message' do
          post api_v1_reservations_path(params: partner_one_params, headers:)
          resp = response.parsed_body
          expect(resp['errors']).to include('is not a valid status')
          expect(response.status).to eq(422)
        end
      end
      context 'with currency that is not a valid enum' do
        let(:currency) { 'USD' }
        it 'returns an error message' do
          post api_v1_reservations_path(params: partner_one_params, headers:)
          resp = response.parsed_body
          expect(resp['errors']).to include('is not a valid currency')
          expect(response.status).to eq(422)
        end
      end
      context 'with missing email' do
        let(:email) { 'USD' }
        it 'returns an error message' do
          post api_v1_reservations_path(params: partner_one_params, headers:)
          resp = response.parsed_body
          expect(resp['errors']).to include('A valid email address and guest details are required')
          expect(response.status).to eq(422)
        end
      end
    end

    describe 'when there is an existing reservation' do
      context 'and the request has a different reservation code and the guest has a different email' do
        let(:existing_guest) { Guest.create(first_name: 'Bob', last_name: 'Roberts', phone: ['123456789'], email: 'bob.roberts@bnb.com') }
        let(:existing_reservation) do
          existing_guest.reservations.create(code: 'ABC123', start_date: Date.current, end_date: Date.current + 1.day, security_price: 10_000,
                                             payout_amount: 20_000, total_paid: 30_000, currency: 'aud', status: 'accepted', adults: 1, children: 0, infants: 0)
        end
        it 'creates a new guest' do
          existing_guest.reload
          expect { post api_v1_reservations_path(params: partner_one_params, headers:) }.to change { Guest.count }.by(1)
        end
        it 'creates a new reservation' do
          expect { post api_v1_reservations_path(params: partner_one_params, headers:) }.to change { Reservation.count }.by(1)
        end
      end
      context 'and the request has a different reservation code and the guest has the same email as the existing reservation guest' do
        let(:existing_guest) { Guest.create(first_name: 'W', last_name: 'Woodbridge', phone: ['123456789'], email:) }
        let(:existing_reservation) do
          existing_guest.reservations.create(code: 'ABC123', start_date: Date.current, end_date: Date.current + 1.day, security_price: 10_000,
                                             payout_amount: 20_000, total_paid: 30_000, currency: 'aud', status: 'accepted', adults: 1, children: 0, infants: 0)
        end
        it 'does not create a new guest' do
          existing_guest.reload
          expect { post api_v1_reservations_path(params: partner_one_params, headers:) }.to change { Guest.count }.by(0)
        end
        it 'creates a new reservation' do
          expect { post api_v1_reservations_path(params: partner_one_params, headers:) }.to change { Reservation.count }.by(1)
        end
      end
    end
    context 'and the request has the same reservation code and the guest email provided matches the existing reservation guests email' do
      let(:existing_guest) { Guest.create(first_name: 'W', last_name: 'Woodbridge', phone: ['123456789'], email:) }
      let(:existing_reservation) do
        existing_guest.reservations.create(code: reservation_code, start_date: Date.current, end_date: Date.current + 1.day, security_price: 10_000,
                                           payout_amount: 20_000, total_paid: 30_000, currency: 'aud', status: 'accepted', adults: 1, children: 0, infants: 0)
      end
      it 'updates the existing reservation with details in the request' do
        existing_reservation.reload
        post api_v1_reservations_path(params: partner_one_params, headers:)
        expect(existing_reservation.reload.start_date).to eq(start_date.to_date)
      end
      it 'does not create a new reservation' do
        existing_reservation.reload
        expect { post api_v1_reservations_path(params: partner_one_params, headers:) }.to change { Reservation.count }.by(0)
      end
      it 'does not create a new guest' do
        existing_reservation.reload
        expect { post api_v1_reservations_path(params: partner_one_params, headers:) }.to change { Guest.count }.by(0)
      end
    end
    context 'and the request has the same reservation code but the guest email provided does not match the existing reservation guests email' do
      let(:existing_start_date) { Date.current }
      let(:existing_guest) { Guest.create(first_name: 'W', last_name: 'Woodbridge', phone: ['123456789'], email: 'another.user@bnb.com') }
      let(:existing_reservation) do
        existing_guest.reservations.create(code: reservation_code, start_date: existing_start_date, end_date: existing_start_date + 1.day,
                                           security_price: 10_000, payout_amount: 20_000, total_paid: 30_000, currency: 'aud', status: 'accepted', adults: 1, children: 0, infants: 0)
      end
      it 'does not update the existing reservation' do
        existing_reservation.reload
        post api_v1_reservations_path(params: partner_one_params, headers:)
        expect(existing_reservation.start_date).to eq(existing_start_date)
      end
      it 'does not create a new reservation' do
        existing_reservation.reload
        expect { post api_v1_reservations_path(params: partner_one_params, headers:) }.to change { Reservation.count }.by(0)
      end
      it 'does not create a new guest' do
        existing_reservation.reload
        expect { post api_v1_reservations_path(params: partner_one_params, headers:) }.to change { Guest.count }.by(0)
      end
      it 'returns an error' do
        existing_reservation.reload
        post api_v1_reservations_path(params: partner_one_params, headers:)
        resp = response.parsed_body
        expect(resp['errors']).to include('Reservation details provided are for another guest')
        expect(response.status).to eq(422)
      end
    end
  end
end
