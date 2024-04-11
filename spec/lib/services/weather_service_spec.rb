# frozen_string_literal: true
require "services/weather_service"

RSpec.describe WeatherService do
  describe "#current_weather" do
    describe "happy path" do
      it "fetches the current weather for a coordinate in fahrenheit" do
        VCR.use_cassette "weather_service/current_weather/happy_path_fahrenheit", allow_unused_http_interactions: false, record: :new_episodes do
          result = WeatherService.new(
            latitude: 40.74865337901453,
            longitude: -73.98524258380219,
            units: "fahrenheit"
          ).current_weather

          expect(result).to eql({ "current_temp" => 50.18, "low_temp" => 47.25, "high_temp" => 52.99 })
        end
      end

      it "fetches the current weather for a coordinate in celsius" do
        VCR.use_cassette "weather_service/current_weather/happy_path_celsius", allow_unused_http_interactions: false, record: :new_episodes do
          result = WeatherService.new(
            latitude: 40.74865337901453,
            longitude: -73.98524258380219,
            units: "celsius"
          ).current_weather

          expect(result).to eql({ "current_temp" => 10.09, "low_temp" => 8.46, "high_temp" => 11.65 })
        end
      end

      it "fetches the current weather for a coordinate in kelvin" do
        VCR.use_cassette "weather_service/current_weather/happy_path_kelvin", allow_unused_http_interactions: false, record: :new_episodes do
          result = WeatherService.new(
            latitude: 40.74865337901453,
            longitude: -73.98524258380219,
            units: "kelvin"
          ).current_weather

          expect(result).to eql({ "current_temp" => 283.19, "low_temp" => 281.61, "high_temp" => 284.8 })
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
      it "fetches the weather forecast or a coordinate in fahrenheit" do
        VCR.use_cassette "weather_service/weather_forecast/happy_path_fahrenheit", allow_unused_http_interactions: false, record: :new_episodes do
          result = WeatherService.new(
            latitude: 40.74865337901453,
            longitude: -73.98524258380219,
            units: "fahrenheit"
          ).weather_forecast

          expect(result.first).to eql(
            "current_temp" => 50.13, "low_temp" => 50.13, "high_temp" => 52.97, "time" => "2024-04-11 09:00:00"
          )
          expect(result.last).to eql(
            "current_temp" => 56.12, "low_temp" => 56.12, "high_temp" => 56.12, "time" => "2024-04-16 06:00:00"
          )
          expect(result.length).to eql 40
        end
      end
    end
  end
end
