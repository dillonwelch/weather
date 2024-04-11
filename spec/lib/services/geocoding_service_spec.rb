# frozen_string_literal: true

require 'services/geocoding_service'

RSpec.describe GeocodingService do
  vcr_params = { allow_unused_http_interactions: false, record: :new_episodes }

  describe '#coordinates' do
    describe 'happy path' do
      it 'fetches coordinates for an address' do
        VCR.use_cassette 'geocoding_service/happy_path', vcr_params do
          coords = described_class.new(
            street: '20 W 34th St.',
            city: 'New York',
            state: 'NY',
            zip: '10001'
          ).coordinates

          expect(coords).to contain_exactly({ 'longitude' => -73.98524258380219, 'latitude' => 40.74865337901453 })
        end
      end
    end

    describe 'missing address' do
      it 'returns an empty array' do
        VCR.use_cassette 'geocoding_service/missing_address', vcr_params do
          coords = described_class.new(
            street: 'I do not exist',
            city: 'New York',
            state: 'NY',
            zip: '12345'
          ).coordinates

          expect(coords).to be_empty
        end
      end
    end
  end
end
