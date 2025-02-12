# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Place do
  let(:params) do
    { lat: 40.7093358, lng: -73.9565551, cached: false, address: "Brooklyn, NY 11211, USA" }
  end
  subject(:place) { described_class.new(params) }

  context 'with lat and lng params present' do
    it { is_expected.to be_valid }
  end

  context 'with lat or lng missing' do
    let(:params) { { lng: -73.9565551, cached: false, address: "Brooklyn, NY 11211, USA" } }

    it { is_expected.not_to be_valid }
  end

  describe '#coords' do
    it 'returns the coordinates joined' do
      expect(place.coords).to eq([params[:lat], params[:lng]].join(','))
    end
  end
end
