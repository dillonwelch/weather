class WeatherController < ApplicationController
  def index
  end

  def search
    # TODO: docs
    # TODO: validate zip
    # TODO: options for units
    # TODO: dropdown for state
    puts params
    client = OpenWeather::Client.new(
      api_key: ENV['OPEN_WEATHER_API_KEY']
    )
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
    results = resp["result"]["addressMatches"]
    coords = []
    results.each do |result|
      coords << result["coordinates"] # TODO: use fancy map
    end
    puts coords
    # weather = client.current_weather(units: "imperial", zip: params[:zip])["main"]
    # @current_temp = weather["temp"]
    # @low_temp = weather["temp_min"]
    # @high_temp = weather["temp_max"]
    render "index"
  end
end