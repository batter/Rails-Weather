# frozen_string_literal: true

class WeatherService
  delegate :api_key, to: :class

  attr_accessor :place

  def initialize(place)
    @place = place
  end

  def parsed_response
    @parsed_response ||= Rails.cache.fetch(cache_key) { JSON.parse(response.body) }
  end

  def cached?
    Rails.cache.exist?(cache_key)
  end

  protected

  def response
    @response ||= Faraday.get("https://api.pirateweather.net/forecast/#{api_key}/#{place.coords}")
  end

  def cache_key
    "coords/#{place.coords}"
  end

  private

  def self.api_key
    @api_key ||= Rails.application.credentials.pirate_weather_api_key[Rails.env]
  end
end
