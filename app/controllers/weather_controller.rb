class WeatherController < ApplicationController
  def index
  end

  def search
    # TODO: docs
    # TODO: validate zip
    # TODO: options for units
    puts params
    client = OpenWeather::Client.new(
      api_key: ENV['OPEN_WEATHER_API_KEY']
    )
    weather = client.current_weather(units: "imperial", zip: params[:zip])["main"]
    @current_temp = weather["temp"]
    @low_temp = weather["temp_min"]
    @high_temp = weather["temp_max"]
    render "index"
  end
end