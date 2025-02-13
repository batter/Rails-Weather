# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GeocodingService do
  let(:address) { '11211' }
  let(:formatted_address) { 'Brooklyn, NY 11211, USA' }

  subject(:service) { described_class.new(address) }

  context '#coords' do
    context 'with valid arguments' do
      let(:coords) { { 'lat' =>  40.7093358, 'lng' => -73.9565551 } }

      it 'returns valid coordinates' do
        VCR.use_cassette("geolocation/#{address}") do
          expect(service.coords).to include(coords)
        end
      end
    end

    context 'with invalid arguments' do
      let(:address) { ' ' }

      it 'cannot instantiate a valid coord object' do
        VCR.use_cassette("geolocation/blank") do
          expect(service.coords).to be_blank
        end
      end
    end
  end

  context '#formatted_address' do
    context 'with valid arguments' do
      it 'returns a valid address' do
        VCR.use_cassette("geolocation/#{address}") do
          expect(service.formatted_address).to eq(formatted_address)
        end
      end
    end

    context 'with invalid arguments' do
      let(:address) { ' ' }

      it 'cannot is blank' do
        VCR.use_cassette("geolocation/blank") do
          expect(service.formatted_address).to be_blank
        end
      end
    end
  end

  context '#place' do
    context 'with valid arguments' do
      it 'returns a valid address' do
        VCR.use_cassette("geolocation/#{address}") do
          expect(service.place).to be_a(Place)
          expect(service.place).to be_valid
          expect(service.place.address).to eq(formatted_address)
        end
      end
    end

    context 'with invalid arguments' do
      let(:address) { ' ' }

      it 'cannot is blank' do
        VCR.use_cassette("geolocation/blank") do
          expect(service.place).to be_blank
        end
      end
    end
  end
end
