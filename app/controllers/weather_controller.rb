require "net/http"

class WeatherController < ApplicationController
  def index
  end

  def search
    # TODO: docs
    # TODO: validate zip
    # TODO: options for units
    # TODO: dropdown for state
    # TODO: slash search redirect
    # TODO: no results
    # TODO: error state
    base_url = "geocoding.geo.census.gov"
    base_path = "/geocoder/locations/address"
    query = URI::HTTPS.build(host: base_url, path: base_path, query: {
      street: params[:street],
      city: params[:city],
      state: params[:state],
      zip: params[:zip],
      benchmark: 2020,
      format: "json"
    }.to_query)
    resp = JSON.parse(Net::HTTP.get(query))
    puts resp
    results = resp["result"]["addressMatches"]
    coords = []
    results.each do |result|
      coords << result["coordinates"] # TODO: use fancy map
    end

    @temps = []
    coords.each do |coord|
      temp_data = { lat: coord["y"], lon: coord["x"] }
      query = URI::HTTPS.build(
        host: "api.openweathermap.org",
        path: "/data/2.5/weather",
        query: { lat: coord["y"], lon: coord["x"], appid: ENV['OPEN_WEATHER_API_KEY'], units: "imperial"}.to_query,
      )
      resp = JSON.parse(Net::HTTP.get(query))["main"]
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