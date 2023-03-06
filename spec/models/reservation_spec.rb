# frozen_string_literal: true

require 'rails_helper'

describe Reservation do
  describe 'when saving guests' do
    let(:code) { '12345' }
    let(:start_date) { Date.current }
    let(:end_date) { Date.current + 1.day }
    let(:security_price) { 5000 }
    let(:payout_amount) { 2000 }
    let(:total_paid) { 2500 }
    let(:currency) { 'aud' }
    let(:status) { 'accepted' }
    let(:adults) { 2 }
    let(:children) { 2 }
    let(:infants) { 0 }
    let(:guest) do
      Guest.create(first_name: 'John', last_name: 'Smith', email: 'john.smith@email.com', phone: ['01234567'])
    end
    let(:create_reservation) do
      Reservation.create(guest_id: guest.id, code:, start_date:, end_date:, security_price:, payout_amount:, total_paid:,
                         currency:, status:, adults:, children:, infants:)
    end

    context 'with valid attributes' do
      it 'is successful' do
        expect { create_reservation }.to change { Reservation.count }.by(1)
      end
    end

    context 'with invalid attributes' do
      context 'with missing code' do
        let(:code) { nil }
        it 'is unsuccessful' do
          expect { create_reservation }.to change { Reservation.count }.by(0)
        end
      end
      context 'with duplicate of an existing code' do
        let(:code) { nil }
        it 'is unsuccessful' do
          Reservation.create(guest_id: guest.id, code:, start_date:, end_date:,
                             security_price:, payout_amount:, total_paid:, currency:, status:, adults:, children:, infants:)
          expect { create_reservation }.to change { Reservation.count }.by(0)
        end
      end
      context 'with missing start_date' do
        let(:start_date) { nil }
        it 'is unsuccessful' do
          expect { create_reservation }.to change { Reservation.count }.by(0)
        end
      end
      context 'with missing end_date' do
        let(:end_date) { nil }
        it 'is unsuccessful' do
          expect { create_reservation }.to change { Reservation.count }.by(0)
        end
      end
      context 'with missing security_price' do
        let(:security_price) { nil }
        it 'is unsuccessful' do
          expect { create_reservation }.to change { Reservation.count }.by(0)
        end
      end
      context 'with invalid security_price' do
        let(:security_price) { 'some string' }
        it 'is unsuccessful' do
          expect { create_reservation }.to change { Reservation.count }.by(0)
        end
      end
      context 'with missing payout_amount' do
        let(:payout_amount) { nil }
        it 'is unsuccessful' do
          expect { create_reservation }.to change { Reservation.count }.by(0)
        end
      end
      context 'with invalid payout_amount' do
        let(:payout_amount) { 'some string' }
        it 'is unsuccessful' do
          expect { create_reservation }.to change { Reservation.count }.by(0)
        end
      end
      context 'with missing total_paid' do
        let(:total_paid) { nil }
        it 'is unsuccessful' do
          expect { create_reservation }.to change { Reservation.count }.by(0)
        end
      end
      context 'with invalid total_paid' do
        let(:total_paid) { 'some string' }
        it 'is unsuccessful' do
          expect { create_reservation }.to change { Reservation.count }.by(0)
        end
      end
      context 'with missing currency' do
        let(:currency) { nil }
        it 'is unsuccessful' do
          expect { create_reservation }.to change { Reservation.count }.by(0)
        end
      end
      context 'with missing status' do
        let(:status) { nil }
        it 'is unsuccessful' do
          expect { create_reservation }.to change { Reservation.count }.by(0)
        end
      end
      context 'with missing adults' do
        let(:adults) { nil }
        it 'is unsuccessful' do
          expect { create_reservation }.to change { Reservation.count }.by(0)
        end
      end
      context 'with zero adults' do
        let(:adults) { 0 }
        it 'is unsuccessful' do
          expect { create_reservation }.to change { Reservation.count }.by(0)
        end
      end
      context 'with one or more adults' do
        let(:adults) { 1 }
        it 'is successful' do
          expect { create_reservation }.to change { Reservation.count }.by(1)
        end
      end
      context 'with invalid adults' do
        let(:adults) { 'some string' }
        it 'is unsuccessful' do
          expect { create_reservation }.to change { Reservation.count }.by(0)
        end
      end
      context 'with missing children' do
        let(:children) { nil }
        it 'is unsuccessful' do
          expect { create_reservation }.to change { Reservation.count }.by(0)
        end
      end
      context 'with zero children' do
        let(:children) { 0 }
        it 'is successful' do
          expect { create_reservation }.to change { Reservation.count }.by(1)
        end
      end
      context 'with invalid children' do
        let(:children) { 'some string' }
        it 'is unsuccessful' do
          expect { create_reservation }.to change { Reservation.count }.by(0)
        end
      end
      context 'with missing infants' do
        let(:infants) { nil }
        it 'is unsuccessful' do
          expect { create_reservation }.to change { Reservation.count }.by(0)
        end
      end
      context 'with zero infants' do
        let(:infants) { 0 }
        it 'is successful' do
          expect { create_reservation }.to change { Reservation.count }.by(1)
        end
      end
      context 'with invalid infants' do
        let(:infants) { 'some string' }
        it 'is unsuccessful' do
          expect { create_reservation }.to change { Reservation.count }.by(0)
        end
      end
    end
  end
end
