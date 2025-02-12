class WeatherController < ApplicationController
  helper_method :place, :forecast, :cached?

  def index
  end

  def show
    redirect_to root_path and return if params[:address].blank?
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
