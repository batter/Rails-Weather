# frozen_string_literal: true

class Place
  include ActiveModel::API

  attr_accessor :lat, :lng

  alias_method :latitude, :lat
  alias_method :longitude, :lng

  validates :lat, :lng, presence: true
end
