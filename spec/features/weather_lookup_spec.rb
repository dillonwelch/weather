# frozen_string_literal: true

RSpec.describe 'Weather Lookup' do
  vcr_params = { allow_unused_http_interactions: false, record: :new_episodes }

  it 'User looks up the weather without all required data' do
    visit '/'

    fill_in 'Street', with: '20 W 34th St.'

    click_on 'Search'

    expect(page).to have_content(
      'ERROR: A Street must be specified and either the ZIP Code or both City and State must be specified.'
    )
  end

  it 'User looks up the weather with all required data' do
    VCR.use_cassette 'features/weather_lookup/happy_path_fahrenheit', vcr_params do
      visit '/'

      fill_in 'Street', with: '20 W 34th St.'
      fill_in 'City', with: 'New York'
      fill_in 'State', with: 'NY'
      fill_in 'Zip', with: '10001'

      click_on 'Search'

      expect(page).to have_content 'Latitude: 40.74865337901453 Longitude: -73.98524258380219'
      expect(page).to have_content 'Current temp is: 58.24 with a low of 53.89 and a high of 64.22'
      expect(page).to have_content '2024-04-12 00:00:00 57.63'
    end
  end

  it 'User looks up the weather with all required data in Celsius' do
    VCR.use_cassette 'features/weather_lookup/happy_path_celsius', vcr_params do
      visit '/'

      fill_in 'Street', with: '20 W 34th St.'
      fill_in 'City', with: 'New York'
      fill_in 'State', with: 'NY'
      fill_in 'Zip', with: '10001'
      select 'Celsius', from: 'Units'

      click_on 'Search'

      expect(page).to have_content 'Latitude: 40.74865337901453 Longitude: -73.98524258380219'
      expect(page).to have_content 'Current temp is: 14.57 with a low of 12.16 and a high of 17.9'
      expect(page).to have_content '2024-04-12 00:00:00 14.24'
    end
  end
end
