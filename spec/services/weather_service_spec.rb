# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeatherService do
  let(:coords) { { 'lat' =>  40.7093358, 'lng' => -73.9565551 } }
  let(:address) { 'Brooklyn, NY 11211, USA' }
  let(:place_params) { coords.merge(address:) }
  let(:place) { Place.new(place_params) }

  subject(:service) { described_class.new(place) }

  context '#coords' do
    context 'with valid arguments' do
      let(:full_coordinates) { { 'latitude' => coords['lat'], 'longitude' => coords['lng'] } }

      it 'returns valid coordinates' do
        VCR.use_cassette("weather/#{place.coords}") do
          expect(service.parsed_response).to include(full_coordinates)
          expect(service.parsed_response).to have_key('currently')
          expect(service.parsed_response).to have_key('hourly')
        end
      end
    end

    context 'with invalid arguments' do
      let(:coords) { {} }

      it 'makes no request' do
        expect(Faraday).not_to receive(:get)
        service.parsed_response
      end

      it 'returns nil' do
        expect(service.parsed_response).to be_nil
      end
    end
  end
end
