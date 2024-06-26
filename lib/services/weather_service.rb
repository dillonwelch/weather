# frozen_string_literal: true

# Uses the OpenWeatherMap API to fetch either the current weather or the forecasted weather for a set of coordinates.
class WeatherService
  BASE_URL = 'api.openweathermap.org'
  CURRENT_WEATHER_PATH = '/data/2.5/weather'
  WEATHER_FORECAST_PATH = '/data/2.5/forecast'
  UNITS_MAPPING = {
    'fahrenheit' => 'imperial',
    'celsius' => 'metric',
    'kelvin' => 'standard'
  }.freeze

  # @param latitude [Float] Latitude value of the coordinate.
  # @param longitude [Float] Longitude value of the coordinate.
  def initialize(latitude:, longitude:, units:)
    @latitude = latitude
    @longitude = longitude
    @units = units
  end

  # Queries the API to determine the current weather.
  # @return [Hash] Current weather data.
  def current_weather
    Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      query = URI::HTTPS.build(host: BASE_URL, path: CURRENT_WEATHER_PATH, query: query_string)

      resp = JSON.parse(Net::HTTP.get(query))['main']
      {
        'current_temp' => resp['temp'],
        'low_temp' => resp['temp_min'],
        'high_temp' => resp['temp_max']
      }
    end
  end

  # Queries the API to determine the weather forecast for the next 5 days.
  # @return [Array<Hash>] Weather data in 3 hour increments for the next 5 days.
  def weather_forecast
    query = URI::HTTPS.build(host: BASE_URL, path: WEATHER_FORECAST_PATH, query: query_string)

    JSON.parse(Net::HTTP.get(query))['list'].map do |resp|
      {
        'current_temp' => resp['main']['temp'],
        'time' => resp['dt_txt']
      }
    end
  end

  private

  def query_params
    @query_params ||= {
      lat: @latitude,
      lon: @longitude,
      appid: ENV.fetch('OPEN_WEATHER_API_KEY', nil),
      units: UNITS_MAPPING[@units]
    }
  end

  def query_string
    @query_string ||= query_params.to_query
  end

  def cache_key
    return @cache_key if defined? @cache_key

    cache_params ||= query_params.dup
    cache_params.delete(:appid)
    @cache_key = "weather_service:#{cache_params.to_query}"
  end
end
