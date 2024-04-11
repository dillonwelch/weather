# frozen_string_literal: true

require 'net/http'
require 'services/geocoding_service'
require 'services/weather_service'

# Controller for UI
class WeatherController < ApplicationController
  def search
    # TODO: docs in README.md
    #
    # TODO: caching
    # TODO: integration test
    # TODO: update token locally and disable old one
    # TODO: rubocop
    # TODO: Cleanup and document gems
    # TODO: error not clearing out (not resubmitting?)

    if params[:zip].present? || (params[:city].present? && params[:state].present?)
      coordinates = GeocodingService.new(
        street: params[:street],
        city: params[:city],
        state: params[:state],
        zip: params[:zip]
      ).coordinates

      @temps = coordinates.map do |coordinate|
        weather_service = WeatherService.new(
          latitude: coordinate['latitude'],
          longitude: coordinate['longitude'],
          units: params[:units]
        )

        {
          'latitude' => coordinate['latitude'],
          'longitude' => coordinate['longitude'],
          'current' => weather_service.current_weather,
          'extended' => weather_service.weather_forecast
        }
      end
    else
      flash.now[:error] = 'Either the ZIP Code or both City and State must be specified.'
    end

    render 'index'
  end
end
