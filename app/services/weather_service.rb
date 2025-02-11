# frozen_string_literal: true

class WeatherService
  delegate :api_key, to: :class

  attr_accessor :place

  def initialize(place)
    @place = place
  end

  def parsed_response
    @parsed_response ||= JSON.parse(response.body)
  end

  protected

  def response
    @response ||= Faraday.get("https://api.pirateweather.net/forecast/#{api_key}/#{place.lat},#{place.lng}")
  end

  private

  def self.api_key
    @api_key ||= Rails.application.credentials.pirate_weather_api_key[Rails.env]
  end
end
