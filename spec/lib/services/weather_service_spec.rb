# frozen_string_literal: true
require "services/weather_service"

RSpec.describe WeatherService do
  describe "#current_weather" do
    describe "happy path" do
      it "fetches the current weather for a coordinate" do
        VCR.use_cassette "weather_service/current_weather/happy_path", allow_unused_http_interactions: false, record: :new_episodes do
          result = WeatherService.new(
            latitude: 40.74865337901453,
            longitude: -73.98524258380219
          ).current_weather

          expect(result).to eql({ "current_temp" => 50.36, "low_temp" => 46.87, "high_temp" => 53.46 })
        end
      end
    end

    # describe "missing address" do
    #   it "returns an empty array" do
    #     VCR.use_cassette "weather_service/missing_address", allow_unused_http_interactions: false, record: :new_episodes do
    #       coords = WeatherService.new(
    #         street: "I do not exist",
    #         city: "New York",
    #         state: "NY",
    #         zip: "12345"
    #       ).coordinates
    #
    #       expect(coords).to match_array []
    #     end
    #   end
    # end
  end

  describe "#weather_forecast" do
    describe "happy path" do
      it "fetches the weather forecast or a coordinate" do
        VCR.use_cassette "weather_service/weather_forecast/happy_path", allow_unused_http_interactions: false, record: :new_episodes do
          result = WeatherService.new(
            latitude: 40.74865337901453,
            longitude: -73.98524258380219
          ).weather_forecast

          expect(result.first).to eql(
            "current_temp" => 50.2, "low_temp" => 50.2, "high_temp" => 52.97, "time" => "2024-04-11 09:00:00"
          )
        end
      end
    end
  end
end
