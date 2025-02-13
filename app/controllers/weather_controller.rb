class WeatherController < ApplicationController
  helper_method :place, :forecast, :cached?

  before_action :ensure_credentials_exist_for_env!, except: :missing_credentials

  def index; end

  def show
    if params[:address].blank?
      redirect_to root_path, flash: { error: 'Please enter a valid address' }
    elsif place.blank?
      redirect_to root_path, flash: { warning: 'Address could not be resolved' }
    end
  end

  def missing_credentials
    redirect_to root_path if GeocodingService.api_key.present? && WeatherService.api_key.present?
  end

  private

  def place
    @place ||= GeocodingService.new(params[:address]).place
  end

  def weather_service
    @weather_service ||= WeatherService.new(place)
  end

  def cached?
    weather_service.cached?
  end

  def forecast
    @forecast ||= weather_service.parsed_response
  end

  def ensure_credentials_exist_for_env!
    return if GeocodingService.api_key.present? && WeatherService.api_key.present?

    redirect_to(missing_credentials_path) and return
  end
end
