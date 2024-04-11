# frozen_string_literal: true

# Uses the US Census Geocoding API to turn an address into coordinates.
class GeocodingService
  BASE_URL = 'geocoding.geo.census.gov'
  BASE_PATH = '/geocoder/locations/address'

  # @param street [String] Street portion of the address.
  # @param city [String] City portion of the address.
  # @param state [String] State portion of the address.
  # @param zip [String] Zip portion of the address.
  def initialize(street:, city:, state:, zip:)
    @street = street
    @city = city
    @state = state
    @zip = zip
  end

  # Queries the API to determine the coordinates.
  # @example Coordinates for the Empire State Building.
  #   [{ "longitude" => -73.98524258380219, "latitude" => 40.74865337901453 }]
  # @return [Array<Hash<String, Float>>, Array] List of coordinates with keys for longitude and latitude,
  #   or an empty array if no results were found.
  def coordinates
    Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      query = URI::HTTPS.build(
        host: BASE_URL,
        path: BASE_PATH,
        query: query_params
      )

      JSON.parse(Net::HTTP.get(query))['result']['addressMatches'].map do |result|
        { 'latitude' => result['coordinates']['y'], 'longitude' => result['coordinates']['x'] }
      end
    end
  end

  private

  def query_params
    @query_params ||= {
      street: @street, city: @city, state: @state, zip: @zip, benchmark: 2020, format: 'json'
    }.to_query
  end

  def cache_key
    "geocoding_service:#{query_params}"
  end
end
