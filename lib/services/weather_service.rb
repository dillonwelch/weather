# frozen_string_literal: true

class WeatherService
  BASE_URL = "api.openweathermap.org"
  CURRENT_WEATHER_PATH = "/data/2.5/weather"
  WEATHER_FORECAST_PATH = "/data/2.5/forecast"

  def initialize(latitude:, longitude:)
    @latitude = latitude
    @longitude = longitude
  end

  def current_weather
    query = URI::HTTPS.build(
      host: BASE_URL,
      path: CURRENT_WEATHER_PATH,
      query: {
        lat: @latitude,
        lon: @longitude,
        appid: ENV['OPEN_WEATHER_API_KEY'],
        units: "imperial"
      }.to_query
    )
    JSON.parse(Net::HTTP.get(query))["main"]
  end
end
