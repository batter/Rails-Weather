require 'rails_helper'

RSpec.describe "Weathers", type: :request do
  describe "GET /" do
    it 'renders the index view' do
      get('/')

      expect(response).to have_http_status(:ok)
    end

    context 'Google Maps API key missing' do
      before { allow(GeocodingService).to receive(:api_key) }

      it 'redirects to the missing credentials page' do
        get('/')

        expect(response).to redirect_to(missing_credentials_path)
        follow_redirect!
        expect(response.body).to include('Google Maps API Key')
      end
    end

    context 'Pirate Weather API key missing' do
      before { allow(WeatherService).to receive(:api_key) }

      it 'redirects to the missing credentials page' do
        get('/')

        expect(response).to redirect_to(missing_credentials_path)
        follow_redirect!
        expect(response.body).to include('Pirate Weather API Key')
      end
    end
  end

  describe "GET /forecast" do
    context 'empty address param' do
      it 'redirects with an error message' do
        get('/forecast?address=+')

        expect(flash[:error]).to eq('Please enter a valid address')
        expect(response).to redirect_to(root_path)
      end
    end

    context 'invalid address' do
      it 'redirects with a warning message' do
        VCR.use_cassette("geolocation/invalid") do
          get('/forecast?address=11')

          expect(flash[:warning]).to eq('Address could not be resolved')
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'valid address' do
      before { VCR.insert_cassette('weather/40.7093358,-73.9565551') }
      after { VCR.eject_cassette('weather/40.7093358,-73.9565551') }

      it 'displays the weather forecast' do
        VCR.use_cassette("geolocation/11211") do
          get('/forecast?address=11211')

          expect(response).to render_template(:show)
          expect(response.body).to include('Brooklyn, NY 11211, USA')
          expect(response.body).to include('Currently:')
          expect(response.body).to include("<div class='weather_panel'>")
        end
      end
    end
  end
end
