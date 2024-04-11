# frozen_string_literal: true
require "services/geocoding_service"

RSpec.describe GeocodingService do
  describe "#coordinates" do
    it "fetches coordinates for an address" do
      VCR.use_cassette "geocoding_service/happy_path", allow_unused_http_interactions: false, record: :new_episodes do
        coords = GeocodingService.new(
          street: "20 W 34th St.",
          city: "New York",
          state: "NY",
          zip: "10001"
        ).coordinates

        expect(coords).to match_array [{ "longitude" => -73.98524258380219, "latitude" => 40.74865337901453 }]
      end
    end
  end
end