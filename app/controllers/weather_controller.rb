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

    @temps = []
    coords.each do |coord|
      temp_data = { lat: coord["y"], lon: coord["x"] }

      resp = WeatherService.new(latitude: coord["y"], longitude: coord["x"]).current_weather
      temp_data[:current] = { current_temp: resp["temp"], low_temp: resp["temp_min"], high_temp: resp["temp_max"]}
      temp_data[:extended] = []

      query = URI::HTTPS.build(
        host: "api.openweathermap.org",
        path: "/data/2.5/forecast",
        query: { lat: coord["y"], lon: coord["x"], appid: ENV['OPEN_WEATHER_API_KEY'], units: "imperial"}.to_query,
      )
      resps = JSON.parse(Net::HTTP.get(query))["list"]
      resps.each do |bleh|
        resp = bleh["main"]
        temp_data[:extended] << { current_temp: resp["temp"], low_temp: resp["temp_min"], high_temp: resp["temp_max"], time: bleh["dt_txt"]}
      end

      @temps << temp_data
    end

    # weather = client.current_weather(units: "imperial", zip: params[:zip])["main"]
    # @current_temp = weather["temp"]
    # @low_temp = weather["temp_min"]
    # @high_temp = weather["temp_max"]
    render "index"
  end
end