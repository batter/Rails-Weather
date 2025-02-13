# frozen_string_literal: true

# Service for fetching the weather forecast from Pirate Weather's API for specific geocoordinates
# for expected usage documentation see spec/services/weather_service_spec.rb

class WeatherService
  FORECAST_BASE_URI = 'https://api.pirateweather.net/forecast/'

  delegate :api_key, to: :class

  attr_accessor :place

  def initialize(place)
    @place = place
  end

  def parsed_response
    return if place.invalid?

    @parsed_response ||=
      Rails.cache.fetch(cache_key, expires_in: 30.minutes) { JSON.parse(response.body) }
  end

  def cached?
    Rails.cache.exist?(cache_key)
  end

  protected

  def response
    @response ||= Faraday.get("#{FORECAST_BASE_URI}#{api_key}/#{place.coords}") if place.valid?
  end

  def cache_key
    "address/#{place.address}"
  end

  private

  def self.api_key
    @api_key ||= Rails.application.credentials.pirate_weather_api_key[Rails.env]
  end
end
