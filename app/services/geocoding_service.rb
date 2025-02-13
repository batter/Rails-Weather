# frozen_string_literal: true

# Service for fetching geolocation coordinates from google maps API given an address
# for expected usage documentation see spec/services/geocoding_service_spec.rb

class GeocodingService
  GOOGLEMAPS_BASE_URI = 'https://maps.googleapis.com/maps/api/geocode/json'

  delegate :api_key, to: :class
  delegate :success?, to: :response

  def initialize(address)
    @address = address.strip
  end

  def coords
    return {} unless success?

    @coords ||= first_result&.dig('geometry', 'location')&.merge(cached:, address: formatted_address)
  end

  def formatted_address
    @formatted_address ||= first_result&.[]('formatted_address')
  end

  def place
    @place ||= Place.new(coords) if coords.present?
  end

  def cached
    Rails.cache.exist?(cache_key)
  end
  alias_method :cached?, :cached

  protected

  def response
    @response ||= Faraday.get("#{GOOGLEMAPS_BASE_URI}?address=#{@address}&key=#{api_key}")
  end

  def parsed_response
    @parsed_response ||= Rails.cache.fetch(cache_key, expires_in: 30.minutes) { JSON.parse(response.body) }
  end

  def first_result
    @first_result ||= parsed_response['results']&.first
  end

  def cache_key
    "address/#{@address}"
  end

  private

  def self.api_key
    @api_key ||= credential.is_a?(Hash) ? credential[Rails.env] : credential
  end

  def self.credential
    @credential ||= Rails.application.credentials.google_api_key
  end
end
