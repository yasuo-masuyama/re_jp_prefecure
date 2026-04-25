# frozen_string_literal: true

require_relative "config"

module JpPrefecture
  module Base
  end

  class << self
    def config
      @config ||= ReJpPrefecture::Config.new
    end

    def setup
      yield config
    end
  end

  def self.included(base)
    base.extend(Base)
  end
end
