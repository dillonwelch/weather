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

  def coordinates
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
    resp = JSON.parse(Net::HTTP.get(query))
    results = resp["result"]["addressMatches"]
    results.map do |result|
      {
        "latitude" => result["coordinates"]["y"],
        "longitude" => result["coordinates"]["x"]
      }
    end
  end
end