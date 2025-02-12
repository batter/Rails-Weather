# frozen_string_literal: true

class Place
  include ActiveModel::API

  attr_accessor :lat, :lng, :cached, :address

  alias_method :latitude, :lat
  alias_method :longitude, :lng

  validates :lat, :lng, presence: true

  def coords
    "#{lat},#{lng}"
  end
  alias_method :coordinates, :coords
end
