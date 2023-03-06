# frozen_string_literal: true

class PagesController < ApplicationController
  def healthcheck
    render plain: 'ok', status: :ok
  end
end
