# README

## Requirements

* Ruby 3.2.2
* An Open Weather API Key (create an account [here](https://openweathermap.org/api))
  
## Setup

* Create a file called `.env` and add an entry for `OPEN_WEATHER_API_KEY=YOUR_KEY`
* `bundle install`
* `rails s`
* Navigate to `http://localhost:3000/`
* Search!!!

And to run tests:
* `rspec`

And to check for style errors:
* `rubocop`
  
## API Dependencies

This application depends on the following external APIs:
* [US Census Geocoder](https://geocoding.geo.census.gov/geocoder/) for geocoding an address to coordinates.
* [Open Weather](https://openweathermap.org/api) for searching weather data based on coordinates.

## Code Documentation

The application is documented using the [YARD](https://yardoc.org/index.html) standard. Documentation can be generated 
via the [yard](https://github.com/lsegal/yard) gem. IDEs like RubyMine with YARD support should natively pick it up.

## Coding Notes

The APIs are queried directly via Net::HTTP. I originally tried using [open-weather-ruby-client](https://github.com/dblock/open-weather-ruby-client/)
to have an easier interface but it did not have support for forecast data. I could not find a gem for the Census API.

I could have skipped the geocoding step, as OpenWeather has support for zip / city and state searching, I felt that
the geocoding added value via extra precision to your location. A different API like Google's could probably combine
these two steps, but the APIs chosen were easy to setup and also free. :)

As there was no data storage requirement, I did not add any sort of database such as Postgres or any sort of 
ActiveRecord models.

I set up caching via the built-in memory caching to keep the installation light for submission. In a real production 
environment, I would setup Redis for my cache store.

A single controller, WeatherController, was used for both the landing page and search results. While I could have used
ApplicationController for a simple application like this, I like to keep that light and have specific controllers for 
specific pages as a general good practice.

RSpec was used instead of minitest for testing purposes purely out of personal preference.

Rubocop was used to keep the code clean, consistent, and free of obvious performance issues and security flaws.

VCR + webmock were used to make sure that the test suite did not directly make HTTP calls. This allows for the tests
to use consistent responses for consistent results, and also removes the APIs being available as a dependency for 
running the test suite.

## Scalability and Production Environment Concerns

As noted above, replace in-memory cache with Redis. Further testing would need to be done to ensure that the cache key
strategy used was reliable and had a sufficient hit rate.

An evaluation of rate limits, concurrency performance, and uptime would need to be done for both APIs to ensure our
application does not have downtime. Most likely a paid solution would need to be looked at.

Since there aren't any data storage requirements, this could probably be implemented as a single page app via React or
similar and have the JS directly query these APIs and process the results inline. This would make deployment easier (
we could use something like Netlify to deploy the compiled HTML / JS without having to run a Rails server) and also
increase performance due to removing a server request to our application.

There are probably gems and configuration files that come default with Rails that could be removed.

In `config/application.rb`, we could remove `require 'rails/all'` and only include the pieces we need (we don't need 
ActionCable, for instance) to reduce the memory footprint and boot time.

I would want to setup a CI/CD pipeline using Github Actions or similar to automatically run the test suite and deploy
the application.