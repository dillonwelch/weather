# frozen_string_literal: true

class GeocodingService
  BASE_URL = "geocoding.geo.census.gov"
  BASE_PATH = "/geocoder/locations/address"

  def initialize(street:, city:, state:, zip:)
    @street = street
    @city = city
    @state = state
    @zip = zip
  end

  def query
    query = URI::HTTPS.build(
      host: BASE_URL,
      path: BASE_PATH,
      query: {
        street: @street,
        city: @city,
        state: @state,
        zip: @zip,
        benchmark: 2020,
        format: "json"
      }.to_query
    )
    JSON.parse(Net::HTTP.get(query))
  end
end