# frozen_string_literal: true

module Api
  module V1
    class ReservationsController < ApplicationController
      before_action :reservation_and_guest_params

      def create
        if @reservation_and_guest_params.blank?
          return render json: { message: 'There was a problem with the format of your request' },
                        status: :bad_request
        end

        response = if guest.present? && guest.valid?
                     guest.update_or_create_reservation(reservation_params)
                   else
                     'A valid email address and guest details are required'
                   end
        render json: { message: 'There was a problem with your request', errors: response }, status: :unprocessable_entity if response.present?
      end

      private

      def reservation_and_guest_params
        @reservation_and_guest_params ||= ReservationParsers::BaseService.new(params).formatted_params
      end

      def reservation_params
        @reservation_params ||= @reservation_and_guest_params[:reservation] if @reservation_and_guest_params.present?
      end

      def guest_params
        @guest_params ||= @reservation_and_guest_params[:guest] if @reservation_and_guest_params.present?
      end

      def guest
        @guest ||= Guest.find_by(email: guest_params[:email]) || Guest.new(guest_params) if guest_params[:email].present?
      end
    end
  end
end
