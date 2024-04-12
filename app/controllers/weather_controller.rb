# frozen_string_literal: true

require 'net/http'
require 'services/geocoding_service'
require 'services/weather_service'

# Controller for UI
class WeatherController < ApplicationController
  def index
    if params.key?('commit')
      if valid_search_params?
        fetch_weather_data
      else
        flash.now[:error] = I18n.t('search_error')
      end
    end

    render 'index'
  end

  private

  def valid_search_params?
    params[:street].present? && (params[:zip].present? || (params[:city].present? && params[:state].present?))
  end

  def fetch_weather_data
    @temps = coordinates['result'].map do |coordinate|
      weather_service = WeatherService.new(
        latitude: coordinate['latitude'], longitude: coordinate['longitude'], units: params[:units]
      )

      {
        'latitude' => coordinate['latitude'], 'longitude' => coordinate['longitude'],
        'current' => weather_service.current_weather, 'extended' => weather_service.weather_forecast
      }
    end
    @cached = coordinates['cached']
  end

  def coordinates
    @coordinates ||= GeocodingService.new(
      street: params[:street], city: params[:city], state: params[:state], zip: params[:zip]
    ).coordinates
  end
end
