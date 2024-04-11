# frozen_string_literal: true

require 'services/weather_service'

RSpec.describe WeatherService do
  vcr_params = { allow_unused_http_interactions: false, record: :new_episodes }

  describe '#current_weather' do
    describe 'happy path' do
      it 'fetches the current weather for a coordinate in fahrenheit' do
        VCR.use_cassette 'weather_service/current_weather/happy_path_fahrenheit', vcr_params do
          result = described_class.new(
            latitude: 40.74865337901453,
            longitude: -73.98524258380219,
            units: 'fahrenheit'
          ).current_weather

          expect(result).to eql({ 'current_temp' => 50.05, 'high_temp' => 52.97, 'low_temp' => 47.77 })
        end
      end

      it 'fetches the current weather for a coordinate in celsius' do
        VCR.use_cassette 'weather_service/current_weather/happy_path_celsius', vcr_params do
          result = described_class.new(
            latitude: 40.74865337901453,
            longitude: -73.98524258380219,
            units: 'celsius'
          ).current_weather

          expect(result).to eql({ 'current_temp' => 10.03, 'high_temp' => 11.65, 'low_temp' => 8.76 })
        end
      end

      it 'fetches the current weather for a coordinate in kelvin' do
        VCR.use_cassette 'weather_service/current_weather/happy_path_kelvin', vcr_params do
          result = described_class.new(
            latitude: 40.74865337901453,
            longitude: -73.98524258380219,
            units: 'kelvin'
          ).current_weather

          expect(result).to eql({ 'current_temp' => 283.18, 'high_temp' => 284.8, 'low_temp' => 281.91 })
        end
      end
    end
  end

  describe '#weather_forecast' do
    describe 'happy path' do
      it 'fetches the weather forecast or a coordinate in fahrenheit' do
        VCR.use_cassette 'weather_service/weather_forecast/happy_path_fahrenheit', vcr_params do
          result = described_class.new(
            latitude: 40.74865337901453,
            longitude: -73.98524258380219,
            units: 'fahrenheit'
          ).weather_forecast

          expect(result.first).to eql('current_temp' => 51.1, 'time' => '2024-04-11 12:00:00')
          expect(result.last).to eql('current_temp' => 55.04, 'time' => '2024-04-16 09:00:00')
          expect(result.length).to be 40
        end
      end

      it 'fetches the weather forecast or a coordinate in celsius' do
        VCR.use_cassette 'weather_service/weather_forecast/happy_path_celsius', vcr_params do
          result = described_class.new(
            latitude: 40.74865337901453,
            longitude: -73.98524258380219,
            units: 'celsius'
          ).weather_forecast

          expect(result.first).to eql('current_temp' => 10.61, 'time' => '2024-04-11 12:00:00')
          expect(result.last).to eql('current_temp' => 12.8, 'time' => '2024-04-16 09:00:00')
          expect(result.length).to be 40
        end
      end

      it 'fetches the weather forecast or a coordinate in kelvin' do
        VCR.use_cassette 'weather_service/weather_forecast/happy_path_kelvin', vcr_params do
          result = described_class.new(
            latitude: 40.74865337901453,
            longitude: -73.98524258380219,
            units: 'kelvin'
          ).weather_forecast

          expect(result.first).to eql('current_temp' => 283.76, 'time' => '2024-04-11 12:00:00')
          expect(result.last).to eql('current_temp' => 285.95, 'time' => '2024-04-16 09:00:00')
          expect(result.length).to be 40
        end
      end
    end
  end
end
