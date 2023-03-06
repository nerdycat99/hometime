# frozen_string_literal: true

require 'rails_helper'

describe Guest do
  describe 'when saving guests' do
    let(:first_name) { 'joe' }
    let(:last_name) { 'satriani' }
    let(:email) { 'joe.satriani@email.com' }
    let(:phone) { %w[123 456] }
    let(:create_guest) { Guest.create(first_name:, last_name:, email:, phone:) }

    context 'with valid attributes' do
      it 'is successful' do
        expect { create_guest }.to change { Guest.count }.by(1)
      end
    end

    context 'with invalid attributes' do
      context 'with missing first_name' do
        let(:first_name) { nil }
        it 'is unsuccessful' do
          expect { create_guest }.to change { Guest.count }.by(0)
        end
      end
      context 'with missing last_name' do
        let(:last_name) { nil }
        it 'is unsuccessful' do
          expect { create_guest }.to change { Guest.count }.by(0)
        end
      end
      context 'with missing email' do
        let(:email) { nil }
        it 'is unsuccessful' do
          expect { create_guest }.to change { Guest.count }.by(0)
        end
      end
      context 'with invalid email' do
        let(:email) { 'somethingnotcorrect.place' }
        it 'is unsuccessful' do
          expect { create_guest }.to change { Guest.count }.by(0)
        end
      end
      context 'with duplicate of existing guests email' do
        let(:email) { 'somethingnotcorrect.place' }
        it 'is unsuccessful' do
          Guest.create(first_name: 'original', last_name: 'person', email:, phone:)
          expect { create_guest }.to change { Guest.count }.by(0)
        end
      end
      context 'with missing phone numbers' do
        let(:phone) { nil }
        it 'is unsuccessful' do
          expect { create_guest }.to change { Guest.count }.by(0)
        end
      end
      context 'with empty phone numbers array' do
        let(:phone) { [] }
        it 'is unsuccessful' do
          expect { create_guest }.to change { Guest.count }.by(0)
        end
      end
    end
  end
end
