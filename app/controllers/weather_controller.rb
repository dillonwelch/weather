require "net/http"
require "services/geocoding_service"
require "services/weather_service"

class WeatherController < ApplicationController
  def search
    # TODO: docs in README.md
    #
    # TODO: validate zip / presence of values
    # TODO: error state
    # TODO: cleanup JS
    # TODO: cleanup CSS
    # TODO: caching
    # TODO: integration test
    # TODO: token leak in VCR files
    # TODO: rubocop
    # TODO: rerecord all cassettes when done / set time const
    # TODO: extra temp values are not actually helpful for forecast?
    # TODO: need to output timezones

    coordinates = GeocodingService.new(
      street: params[:street],
      city: params[:city],
      state: params[:state],
      zip: params[:zip]
    ).coordinates

    @temps = coordinates.map do |coordinate|
      weather_service = WeatherService.new(
        latitude: coordinate["latitude"],
        longitude: coordinate["longitude"],
        units: params[:units]
      )

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