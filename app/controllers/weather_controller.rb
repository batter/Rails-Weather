class WeatherController < ApplicationController
  helper_method :place, :forecast, :cached?

  def index; end

  def show
    if params[:address].blank?
      redirect_to root_path, flash: { error: 'Please enter a valid address' }
    elsif place.blank?
      redirect_to root_path, flash: { warning: 'Address could not be resolved' }
    end
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
end
