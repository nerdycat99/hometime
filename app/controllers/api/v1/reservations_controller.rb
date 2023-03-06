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

        Rails.logger.debug @reservation_and_guest_params.inspect
      end

      private

      def reservation_and_guest_params
        @reservation_and_guest_params ||= ReservationParsers::BaseService.new(params).formatted_params
      end
    end
  end
end
