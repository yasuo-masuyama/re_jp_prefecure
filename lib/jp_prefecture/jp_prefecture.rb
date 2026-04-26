# frozen_string_literal: true

require_relative "config"
require_relative "base"

module JpPrefecture
  class << self
    def config
      @config ||= JpPrefecture::Config.new
    end

    def setup
      yield config
    end

    def included(base)
      base.extend(Base)
    end
  end
end
