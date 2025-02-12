class WeatherController < ApplicationController
  helper_method :weather_service

  def index
  end

  def show
    redirect_to root_path and return if params[:address].blank?
  end

  private

  def weather_service
    @weather_service ||= begin
      place = GeocodingService.new(params[:address]).place
      WeatherService.new(place)
    end
  end
end
