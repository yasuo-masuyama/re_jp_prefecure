# frozen_string_literal: true

require_relative "config"
require_relative "base"

module JpPrefecture
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
