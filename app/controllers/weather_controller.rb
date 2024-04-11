require "net/http"
require "services/geocoding_service"
require "services/weather_service"

class WeatherController < ApplicationController
  def index
  end

  def search
    # TODO: docs
    # TODO: validate zip / presence of values
    # TODO: options for units
    # TODO: dropdown for state
    # TODO: slash search redirect
    # TODO: no results
    # TODO: error state
    # TODO: cleanup JS
    # TODO: cleanup CSS
    # TODO: caching

    coordinates = GeocodingService.new(
      street: params[:street],
      city: params[:city],
      state: params[:state],
      zip: params[:zip]
    ).coordinates

    @temps = coordinates.map do |coordinate|
      weather_service = WeatherService.new(latitude: coordinate["latitude"], longitude: coordinate["longitude"])

      {
        "latitude" => coordinate["latitude"],
        "longitude" => coordinate["longitude"],
        "current" => weather_service.current_weather,
        "extended" => weather_service.weather_forecast
      }
    end

    render "index"
  end
end