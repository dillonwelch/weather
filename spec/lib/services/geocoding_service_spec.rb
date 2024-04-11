# frozen_string_literal: true
require "services/geocoding_service"

RSpec.describe GeocodingService do
  describe "#coordinates" do
    it "fetches coordinates for an address" do
      coords = GeocodingService.new(
        street: "20 W 34th St.",
        city: "New York",
        state: "NY",
        zip: "10001"
      ).coordinates

      expected = {"x"=>-73.98524258380219, "y"=>40.74865337901453}
      expect(coords).to eq [expected]
    end
  end
end