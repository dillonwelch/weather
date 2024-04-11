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

    coords = GeocodingService.new(
      street: params[:street],
      city: params[:city],
      state: params[:state],
      zip: params[:zip]
    ).coordinates

    @temps = [] # TODO: only assume one?
    coords.each do |coord|
      temp_data = { lat: coord["latitude"], lon: coord["longitude"] } # TODO: rename

      weather_service = WeatherService.new(latitude: coord["latitude"], longitude: coord["longitude"])

      temp_data["current"] = weather_service.current_weather
      temp_data["extended"] = weather_service.weather_forecast # TODO: rename from extended

      @temps << temp_data
    end

    render "index"
  end
end