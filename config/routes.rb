# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#healthcheck'
  namespace :api do
    namespace :v1 do
      resource :reservations, only: [:create]
    end
  end
end
