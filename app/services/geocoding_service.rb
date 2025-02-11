# frozen_string_literal: true

class GeocodingService
  delegate :api_key, to: :class

  def initialize(address)
    @address = address
  end

  def coords
    return {} unless response.success?

    @coords ||= begin
      result = parsed_response['results']&.first
      result&.dig('geometry', 'location')
    end
  end

  def place
    @place ||= Place.new(coords)
  end

  protected

  def parsed_response
    @parsed_response ||= JSON.parse(response.body)
  end

  def response
    @response ||= Faraday.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{@address}&key=#{api_key}")
  end

  private

  def self.api_key
    @api_key ||= Rails.application.credentials.google_api_key[Rails.env]
  end
end
